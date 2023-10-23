module Nexpose
  module ScanAndImport
    class TaskConfig < ::TaskConfig

      #
      # Attributes
      #
      attr_accessor :import_run_id
      attr_accessor :whitelist_hosts
      attr_accessor :blacklist_hosts
      attr_accessor :scan
      attr_accessor :scan_template
      attr_accessor :autotag_os
      attr_accessor :tags
      attr_accessor :sites
      attr_accessor :import_run
      attr_accessor :preserve_hosts

      #
      # Validations
      #
      validate  :whitelist_valid
      validate  :blacklist_valid

      # These values differ from the defaults used in general
      # Nexpose import cases:
      SPECIAL_NX_IMPORT_ATTRS = { metasploitable_only: true,
                                  latest_scan_only: true
      }.freeze



      def initialize(args={})
        super(args)
        setup_run args if args[:launch_now] || args[:console_id]

        @import_run_id = args[:import_run_id]
        @whitelist_hosts = args[:whitelist_string]
        @blacklist_hosts = args[:blacklist_string]
        @scan = args[:scan]
        @scan_template = args[:scan_template]
        @autotag_os = args[:autotag_os]
        @tags = args[:tags]
        @import_run = ::Nexpose::Data::ImportRun.where(id: @import_run_id).first
        @import_run.choose_sites(args[:sites]) if args[:launch_now]
        @preserve_hosts = set_default_boolean(args[:preserve_hosts], false)
        @build_matches = set_default_boolean(args[:build_matches],true)
      end

      #
      # @param args [Hash] the params hash that have the options for this config
      #
      def setup_run args
        #If we are doing a scan and import, then we want a new import run
        if args[:console_id]
          import_run = ::Nexpose::Data::ImportRun.create(
            nx_console_id: args[:console_id],
            user: args[:user],
            workspace:args[:workspace]
          )
          args.merge!(import_run_id: import_run.id)
        end
      end

      # @return [Hash["task_id"]] the id of the Vuln Validation Commander task
      def rpc_call
        client.start_scan_and_import(config_to_hash)
      end

      # @return [Hash] that is passed to the module
      def config_to_hash
        {
          'DS_IMPORT_RUN_ID' => @import_run_id,
          'DS_SCAN' => @scan,
          'DS_WHITELIST_HOSTS' => @whitelist_hosts,
          'DS_BLACKLIST_HOST' => @blacklist_hosts,
          'DS_PRESERVE_HOSTS'   => @preserve_hosts,
          'DS_SCAN_TEMPLATE' => @scan_template,
          'DS_AUTOTAG_OS' => @autotag_os,
          'DS_AUTOTAG_TAGS' => @tags.gsub(' ','_'),
          'DS_BUILD_MATCHES' => @build_matches,
          'workspace' => @import_run.workspace.name
        }
      end

      def valid?
        if @scan
          whitelist_valid
          blacklist_valid
        end

        errors.empty?
      end


    end
  end
end
