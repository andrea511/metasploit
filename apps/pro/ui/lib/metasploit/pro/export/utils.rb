module Metasploit::Pro::Export::Utils

  def export_logger
    unless instance_variable_defined? :@export_logger
      log_pathname = File.join(Export::LOG_FILE)
      @export_logger = Logger.new(log_pathname)
      @export_logger.level = Logger::INFO
      @export_logger.formatter = proc do |severity, datetime, program_name, msg|
        "#{severity}: #{datetime}: (#{self.id}) #{msg}\n"
      end
    end
    @export_logger
  end

  # Returns export file path based on selected
  # name and type
  def export_file_path
    file_extension = Export::TYPES_EXTENSIONS[self.export_type]
    "#{File.join(Export::EXPORT_DIR, self.name)}.#{file_extension}"
  end

  # Find call conditions scope to passed object
  def find_conditions(scope)
    case scope
      when :workspace
        ["workspace_id = #{self.workspace_id}"]
      else
        []
    end
  end

  # @param host [Mdm::Host] the host to be verified
  # @return [Boolean] if the host is allowed in the export
  def host_allowed?(host)
    address_allowed = allowed_addresses.member? host.address
    workspace_match = (host.workspace == self.workspace)
    (workspace_match && address_allowed)
  end

  # Verify session and service origins, as well as logins, of the passed
  # core are related to a host that is allowed. This is to support
  # white/black listing in export generation.
  # @param core [Metasploit::Credential::Core] to be verified
  # @return [Boolean] if the core is allowed in the export
  def core_allowed?(core)
    origin = core.origin

    origin_allowed = case origin
                     when Metasploit::Credential::Origin::Session
                       host_allowed?(origin.session.host)
                     when Metasploit::Credential::Origin::Service
                       host_allowed?(origin.service.host)
                     else
                       true # manual, import
                     end

    logins_allowed = core.logins.all? {|l| host_allowed?(l.service.host) }

    (origin_allowed && logins_allowed)
  end

  # Legacy format, no idea why all the
  # elements couldn't have used underscore
  def dash(attr)
    attr.gsub('_','-')
  end

  # Legacy approach to making hashes portable.
  # TODO Use base64 of yml
  def marshal_hash(data)
    [Marshal.dump(data)].pack("m").gsub(/\s+/,"")
  end

  # Used in separating PWDump sections
  def hash_divider(width = 40)
    "#" * width
  end

  # @return [Float] time in seconds to complete the export
  def export_duration
    if not self.completed_at
      0
    else
      self.completed_at - self.started_at
    end
  end

  # @return [Boolean] whether dir was successfully created
  def add_filesystem_dir(name)
    begin
      FileUtils.mkdir(name)
    rescue SystemCallError
      logger.error("Unable to create dir for zip: #{name}")
      return false
    end
  end

  def drop_empty_dir(dir)
    if Dir.glob(File.join(dir, '*')).blank?
      FileUtils.rm_rf(dir)
    end
  end

  # Recursively zip all contents of directory
  # @param zip_file_path [String] path to write zip file
  # @param directory [String] path to dir containing contents to be zipped
  def create_zip_file(zip_file_path, directory)
    zip_dir_path = Pathname.new(directory)

    Zip::File.open(zip_file_path, Zip::File::CREATE) do |zipfile|
      Dir[File.join(directory, '**', '**')].each do |file|
        file_path = Pathname.new(file)
        path_in_zip = file_path.relative_path_from(zip_dir_path)
        zipfile.add(path_in_zip, file)
      end
    end
  end

end
