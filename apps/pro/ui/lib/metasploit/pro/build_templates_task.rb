require 'metasploit/pro/build/template'

module Metasploit
  module Pro
    class BuildTemplatesTask < Rake::TaskLib
      def define
        namespace :templates do
          namespace operating_system do
            task :clobber do
              rm_rf destination_pathname
              rm_rf destination_zip_pathname
            end

            task :package do
              if common_source_pathname.directory?
                Metasploit::Pro::Build::Template.process_directory(
                  common_source_pathname,
                  destination_pathname
                )
              end
              if build_type_source_pathname.directory?
                Metasploit::Pro::Build::Template.process_directory(
                  build_type_source_pathname,
                  destination_pathname
                )
              end
            end

            task :package_zip => [:package] do
              chdir(destination_pathname) do
                sh '7z', 'a', destination_zip_pathname.to_path, '.'
              end
            end

            desc "Removes and recreates #{operating_system} #{build_type} templates"
            task :repackage => [:clobber, :package]
          end
        end
      end

      def init(options={})
        options.assert_valid_keys(:operating_system, :build_type)

        # use fetch so it errors if keys are not passed
        @operating_system = options.fetch(:operating_system)
        @build_type = options.fetch(:build_type).to_s
      end

      def initialize(options={}, &block)
        init(options)

        unless block.nil?
          block.call(self)
        end

        define
      end

      attr_reader :operating_system
      attr_reader :build_type

      def build_dir
        case build_type
        when 'installer' then 'install'
        else build_type
        end
      end

      def destination_pathname
        @destination_pathname ||= Rails.root.join('..', 'pkg', build_dir, 'templates', operating_system.to_s).expand_path
      end

      def destination_zip_name
        @destination_zip_name ||= "#{operating_system}-templates.7z"
      end

      def destination_zip_pathname
        @destination_zip_pathname ||= Rails.root.join('..', 'pkg', build_dir, 'templates', destination_zip_name).expand_path
      end

      def common_source_pathname
        @common_source_pathname ||= Rails.root.join('config', 'build', 'common', 'templates', operating_system.to_s)
      end

      def build_type_source_pathname
        @build_type_source_pathname ||= Rails.root.join('config', 'build', build_type, 'templates', operating_system.to_s)
      end

    end
  end
end
