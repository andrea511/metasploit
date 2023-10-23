require 'msf/core/payload_generator'
require 'msf/pro/task'
require 'fileutils'

module Metasploit::Pro::Engine::Rpc::Payloads

  # @return [Hash] with exe and buffer keys that contain arrays of
  # static payload data
  def rpc_payload_formats
    {
        exe: Msf::Util::EXE.to_executable_fmt_formats,
        buffer: Msf::Simple::Buffer.transform_formats
    }
  end

  def rpc_payloads_for_config(datastore)
    local_task = LocalTask.new({})
    local_task.set_local_datastore(datastore)
    if datastore['DS_PAYLOAD_METHOD'] == 'auto'
      plist = local_task.compatible_payloads('bind', 'ipv4')
      plist += local_task.compatible_payloads('reverse', 'ipv4')
    else
      plist = local_task.compatible_payloads(datastore['DS_PAYLOAD_METHOD'], 'ipv4')
    end
    return plist
  end

  # @param generated_payload_id [Integer] the ID of the GeneratedPayload DB object containing our config
  # @return [Hash] with an :errors key
  def rpc_validate_classic_payload(options)
    errors = {}

    formats = (::Msf::Util::EXE.to_executable_fmt_formats + ::Msf::Simple::Buffer.transform_formats).uniq
    unless formats.include? options['format'].downcase
      errors[:format] = 'is invalid'
    end

    payload_module    = options['payload']
    payload_datastore = options['payload_datastore'] || {}

    mod = _lookup_module('payload', payload_module)
    if mod.nil?
      errors['payload'] = 'is invalid'
    else
      mod.options.each do |name, option|
        unless option.valid?(payload_datastore[name])
          errors['payload_datastore'] ||= {}
          errors['payload_datastore'][name] = 'is invalid'
        else
          mod.options[name] = option.normalize(payload_datastore[name])
        end
      end
    end

    encoder_module = options['encoder']
    encoder_datastore = options['encoder_datastore'] || {}

    if encoder_module.present?
      mod = _lookup_module('encoder', encoder_module)
      if mod.nil?
        errors['encoder'] = 'is invalid'
      else
        mod.options.each do |name, option|
          unless option.valid?(encoder_datastore[name])
            errors['encoder_datastore'] ||= {}
            errors['encoder_datastore'][name] = 'is invalid'
          else
            mod.options[name] = option.normalize(encoder_datastore[name])
          end
        end
      end
    end

    if options['size'].present? and options['size'].to_i == 0
      errors['size'] = 'must be greater than 0'
    end

    { result: 'failure', errors: errors }
  end

  # @param generated_payload_id [Integer] the ID of the GeneratedPayload DB object containing our config
  def rpc_generate_classic_payload(generated_payload_id)

    ::Thread.new do
      ApplicationRecord.connection_pool.with_connection do
        generated_payload = GeneratedPayload.find(generated_payload_id)
        _cleanup_old_files(generated_payload)

        # Convert our hashkeys back to symbols since serialisation turned them into strings
        datastore = {}
        datastore.merge!(generated_payload.options['payload_datastore'] || {})
        datastore.merge!(generated_payload.options['encoder_datastore'] || {})
        options = generated_payload.options.merge(:datastore => datastore)

        generator_opts = {}
        options.each_pair {|k,v| generator_opts[k.to_sym] = v }
        generator_opts[:framework] = self.framework

        begin
          payload_generator = ::Msf::PayloadGenerator.new(generator_opts)
          payload = payload_generator.generate_payload
        rescue Msf::PayloadGeneratorError, Msf::EncodingError, ArgumentError, RuntimeError  => e
          generated_payload.generator_error = e.message
          generated_payload.fail!
          break
        end

        begin
          tmp_file = File.open(File.join(::Msf::Config.local_directory, generator_opts[:file_name]), "wb")
          tmp_file.write payload

          generated_payload.file = tmp_file
          generated_payload.finish!

          tmp_file.close
          File.unlink(tmp_file)

          _chown_payload(generated_payload)
        rescue Exception => e
          generated_payload.generator_error = e.message
          generated_payload.fail!
          break
        end
      end
    end

    { success: :ok }
  end

  def rpc_generate_dynamic_stager(generated_payload_id)
    ::Thread.new do
      ApplicationRecord.connection_pool.with_connection do
        generated_payload = GeneratedPayload.find(generated_payload_id)
        _cleanup_old_files(generated_payload)

        # Convert our hashkeys back to symbols since serialisation turned them into strings
        generator_opts = {}
        generated_payload.options.each_pair {|k,v| generator_opts[k.to_sym] = v }

        begin
          payload_generator = ::Pro::DynamicStagers::EXEGenerator.new(generator_opts)
          pe_obj = payload_generator.compile
          tmp_file_path = File.join(::Msf::Config.local_directory, generator_opts[:file_name])
          pe_obj.encode_file(tmp_file_path)
          tmp_file = File.open(tmp_file_path)
          generated_payload.file = tmp_file
          generated_payload.finish!
          tmp_file.close
          File.unlink(tmp_file_path)

          _chown_payload(generated_payload)
        rescue Exception => e
          generated_payload.generator_error = e.message
          generated_payload.fail!
          break
        end
      end
    end

    { success: :ok }
  end

  private

  class LocalTask < Msf::Auxiliary
    include Msf::Pro::Task

    def initialize(info)
      super(info)
    end

    def set_local_datastore(opts)
      opts.each_pair do |key, value|
        datastore[key.gsub(/^DS_/, '')] = value
      end
    end
  end

  # Ensures that the generated payload file, and its container
  # directory can be read/written/deleted from Rails
  def _chown_payload(generated_payload)
    unless Rails.application.platform.win32?
      payloads_dir = Rails.application.root.parent.join('payload_files')

      # only chmod the directories, so we don't re-chmod files
      nested_dirs = Dir.glob(File.join(payloads_dir, '**/**')).select { |path| File.directory?(path) }

      if Rails.env.production?
        FileUtils.chown_R 'daemon', 'root', payloads_dir
        FileUtils.chmod 0750, nested_dirs
      else
        # in non-production, we can make no assumptions about what users
        # are running. so we give access to the payloads to all users, why not!
        FileUtils.chmod 0777, nested_dirs
      end

      # ensure that the file itself is not executable by anyone on the box
      FileUtils.chmod 0644, generated_payload.file.to_s
    end
  end

  def _lookup_module(mtype,mname)
    if mname !~ /^(exploit|payload|nop|encoder|auxiliary|post)\//
      mname = mtype + "/" + mname
    end
    self.framework.modules.create(mname)
  end

  # Destroys previously generated files
  def _cleanup_old_files(generated_payload)
    if File.exist?(generated_payload.file.to_s)
      File.unlink(generated_payload.file.to_s)
      generated_payload.file = ''
    end
  end
end
