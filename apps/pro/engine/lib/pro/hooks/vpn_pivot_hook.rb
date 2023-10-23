require 'metasploit-payloads'
module Pro
  module Hooks
    class VpnPivotHook
      require 'msf/pro/locations'
      include Msf::Pro::Locations
      require 'metasploit-payloads'

      attr_accessor :framework

      def initialize(framework)
        self.framework = framework

        ENV["PRO_DATA_DIRECTORY"] = File.join(pro_data_directory, 'meterpreter')

        ::MetasploitPayloads.module_eval do

          #
          # Get the path to a meterpreter binary by full name.
          #
          def self.meterpreter_path(name, binary_suffix, debug: false)
            file_names = []
            if debug
              # add the debug file first
              debug_suffix = binary_suffix&.gsub(/dll$/, 'debug.dll')
              file_names << "#{name}.#{debug_suffix}".downcase
            end
            file_names << "#{name}.#{binary_suffix}".downcase
            file_names.each do |file_name|
              file = resolve_path(file_name)
              return file unless file.nil?
            end
            nil
          end

          def self.path(*path_parts)
            gem_path = expand(data_directory, ::File.join(path_parts))
            if metasploit_installed?
              msf_path = expand(Msf::Config.data_directory, ::File.join(path_parts))
            end
            pro_path = expand(ENV["PRO_DATA_DIRECTORY"], ::File.join(path_parts))
            readable_path(gem_path, msf_path, pro_path)
          end

          def self.resolve_path(file_name)
            gem_path = expand(local_meterpreter_dir, file_name)
            if metasploit_installed?
              msf_path = expand(msf_meterpreter_dir, file_name)
            end
            pro_path = expand(ENV["PRO_DATA_DIRECTORY"], file_name)
            readable_path(gem_path, msf_path, pro_path)
          end

          def self.readable_path(gem_path, msf_path, pro_path)
            # Try the MSF path first to see if the file exists, allowing the MSF data
            # folder to override what is in the gem. This is very helpful for
            # testing/development without having to move the binaries to the gem folder
            # each time. We only do this is MSF is installed.
            if ::File.readable? msf_path
              warn_local_path(msf_path) if ::File.readable? gem_path
              return msf_path

            elsif ::File.readable? gem_path
              return gem_path
            elsif ::File.readable? pro_path
              return pro_path
            end

            nil
          end
        end
      end
    end
  end
end

Pro::Hooks::Loader.add_hook(Pro::Hooks::VpnPivotHook)
