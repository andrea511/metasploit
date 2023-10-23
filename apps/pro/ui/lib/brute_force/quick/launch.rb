module BruteForce
  module Quick
    # Service Object that is responsible for parsing,validating form inputs, and launching
    # the BruteForce::Guess:Run
    class Launch
      include ActiveModel::Validations
      include Metasploit::Pro::AttrAccessor::Addresses
      include Metasploit::Pro::AttrAccessor::Boolean
      include Metasploit::Pro::IpRangeValidation

      # @attr_reader <String> cred pairs
      attr_accessor :data

      # @attr_reader [File] file of cred pairs
      attr_accessor :file

      attr_reader :workspace

      # @attr [Array<String>] an array of IPs to run against
      attr_accessor :whitelist_hosts

      # @attr [String] user-provided list of IPs, ranges, and tags
      attr_accessor :whitelist_string

      # @attr [Array<String>] an array of IPs to NOT run against
      attr_accessor :blacklist_hosts

      # @attr [String] user-provided list of IPs, ranges, and tags
      attr_accessor :blacklist_string

      # @attr [String] user-provided list of IPs, ranges, and tags
      attr_reader :targets_type

      # @attr [String] include cred pairs from checkbox
      attr_accessor :include_cred_pairs

      # @attr [String] the workspace
      attr_reader :workspace

      # @attr [String] task info with task id
      attr_accessor :task_data

      # @attr [BruteForce::Run] the run
      attr_accessor :bruteforce_run

      validate  :manual_whitelist_valid, on: :stand_alone
      validate  :blacklist_valid, on: :stand_alone
      validate  :manual_cred_pairs, on: :stand_alone
      validate  :file_cred_pairs, on: :stand_alone

      # @param opts [Hash]
      def initialize(opts={})
        unless opts.empty?
          opts = parse_opts(opts)
          init_validations(opts)

          if opts[:workspace]
            @workspace = opts[:workspace]
          end

          create_run(opts,run_config(opts))

          # We're using a older version of ActiveModel :-/ so we still need this
          # Pull args into attr_accessors
          # This has calls that assume whitelist_hosts exist, so
          # it needs to be after the {white,black}_list ivars
          opts.each do |attr, value|
            method = "#{attr}="
            if self.respond_to?(method)
              self.public_send(method, value)
            end
          end if opts
        end

      end

      # Creates the BruteForce::Run and parses addition form inputs for the task
      #
      # @param opts [Hash] the form params
      # @param config [Hash] the opts for the BruteForce::Run
      # @return [Hash] the opts for the task to be created
      def create_run(opts,config)
        @bruteforce_run = BruteForce::Run.create!(config:config)

        @task_options = {
          'DS_BRUTEFORCE_RUN_ID' => @bruteforce_run.id,
          'DS_BRUTEFORCE_GETSESSION' => opts['quick_bruteforce']['options']['payload_settings'],
          'workspace'            => opts['workspace'].name,
          'username'             => opts['current_user'].username
        }

        if opts['payload_settings'] and opts['quick_bruteforce']['options']['payload_settings']
          @task_options.merge!({
                                 'DS_DynamicStager'     => opts['payload_settings']['dynamic_stagers'],
                                 'DS_PAYLOAD_METHOD'    => opts['payload_settings']['connection_type'],
                                 'DS_PAYLOAD_TYPE'      => opts['payload_settings']['payload_type'],
                                 'DS_PAYLOAD_LHOST'     => opts['payload_settings']['listener_host'],
                                 'DS_PAYLOAD_PORTS'     => opts['payload_settings']['listener_ports'],
                               })
        end
      end

      # Parse form inputs to generate config hash for the BruteForce::Run
      #
      # @param opts [Hash] the form params
      # @return [Hash] the parsed config
      def run_config(opts)
        cred_options = opts['quick_bruteforce']['creds'].dup
        cred_file = opts['quick_bruteforce']['file']

        if cred_file and cred_options['add_import_cred_pairs']
          cred_options['import_cred_pairs']['data'] += cred_file.read
        end

        unless cred_options['add_import_cred_pairs']
          cred_options['import_cred_pairs']['data'] = ''
        end

        target_options = {
          blacklist_hosts: opts['quick_bruteforce']['targets']['blacklist_hosts'],
          services: opts['quick_bruteforce']['targets']['services'],
          whitelist_hosts: opts['quick_bruteforce']['targets']['whitelist_hosts']
        }

        run_config = {
          'get_sessions'          => opts['quick_bruteforce']['options']['payload_settings'],
          'overall_timeout'       => opts['overall_timeout'],
          'service_timeout'       => opts['quick_bruteforce']['options']['service_timeout'],
          'stop_on_success'       => opts['quick_bruteforce']['options']['stop_on_guess'],
          'time_between_attempts' => opts['quick_bruteforce']['options']['time_between_attempts']
        }

        {
          cred_options: cred_options,
          run_config: run_config,
          mutation_options: opts['mutation_options'],
          target_options: target_options,
        }
      end

      # Expand IP addresses and set instance variables needed for validations
      #
      # @param opts [Hash] the form params
      def init_validations(opts)
        @targets_type = opts[:quick_bruteforce][:targets][:type]
        @include_cred_pairs = opts[:quick_bruteforce][:creds][:add_import_cred_pairs]
        @data = opts[:quick_bruteforce][:creds][:import_cred_pairs][:data]
        if !@data.blank? && @data[-1] != "\n"
          data << "\n"
        end

        @file = opts[:quick_bruteforce][:file]

        expand_opts = {:workspace => opts[:workspace]}
        @whitelist_hosts = Metasploit::Pro::AddressUtils.expand_ip_ranges(
          opts[:quick_bruteforce][:targets][:whitelist_hosts] || '', expand_opts
        )
        @blacklist_hosts = Metasploit::Pro::AddressUtils.expand_ip_ranges(
          opts[:quick_bruteforce][:targets][:blacklist_hosts] || '', expand_opts
        )
      end

      # The method that executes the module
      def execute
        @task_data = Pro::Client.get.start_brute_force_quick(@task_options)
        set_presenter
        @bruteforce_run.task_id = @task_data['task_id']
        @bruteforce_run.save
      end

      # @return (see #result=)
      # @return [nil]
      def run
        return unless valid?
        execute
      end

      # Pick presenter based on whether or not we selected get sessions
      #
      def set_presenter
        task = Mdm::Task.find(@task_data['task_id'])
        if @task_options['DS_PAYLOAD_LHOST']
          task.presenter = :brute_force_guess_quick_session
        else
          task.presenter = :brute_force_guess_quick
        end
        task.save
      end


      # Parse form inputs and normalize stand alone and task chain inputs
      #
      # @param opts [Hash] the form params
      def parse_opts(opts)
        parsed_opts = ActiveSupport::HashWithIndifferentAccess.new
        convert_strings(opts,parsed_opts)
        parsed_opts
      end

      # Recursively convert "true"/"false" values in a hash into booleans
      #
      # @param opts [Hash] the form params
      # @param parsed_opts [Hash] the current iterated hash
      # @return [Hash] the normalized hash
      def convert_strings(opts,parsed_opts)
        opts.each do |key,value|
          if value.instance_of?(ActiveSupport::HashWithIndifferentAccess) || value.instance_of?(Hash)
            parsed_opts[key]= ActiveSupport::HashWithIndifferentAccess.new
            convert_strings(value,parsed_opts[key])
          else
            parsed_opts[key] = value
            if value=='true'
              parsed_opts[key] = true
            end
            if value=='false'
              parsed_opts[key] = false
            end
          end
        end
      end

      # Custom formatted errors_hash
      #
      # @return [Hash] the errors hash to be parsed by the UI
      def errors_hash
        formErrors = errors.as_json
        {
          quick_bruteforce: {
            file: formErrors[:file],
            targets: {
              whitelist_hosts: formErrors[:whitelist_string],
              blacklist_hosts: formErrors[:blacklist_string]
            },
            creds:{
              import_cred_pairs: {
                data: formErrors[:data]
              }
            }
          }
        }
      end

      # Validates format of cred pair text input
      def manual_cred_pairs
        if @include_cred_pairs
          #Match public, private pairs delimitted by newline/carriage return
          unless /^([^[:blank:]]+[[[:space:]][^[:blank:]]]+(\n))+$/.match(@data) || @data.blank?
            errors.add :data, "Invalid format."
          end
        end
      end

      # Validates file type of uploaded cred file
      def file_cred_pairs
        if @file and @include_cred_pairs
          unless @file.original_filename.include? '.txt'
            errors.add :file, "Invalid file type. Must provide a .txt file"
          end
        end
      end


      # Validates IP address range for whitelist hosts
      def manual_whitelist_valid
        if @targets_type == "manual"
          whitelist_valid
        end
      end


      #Class Methods

      # Creates an instance of the current task and calls the run method on the new instance.
      #
      # @param *args args to pass to class constructor
      # @return [BruteForce::Quick::Launch] the service object
      def self.run(*args)
        new(*args).tap{|instance| instance.send(:run)}
      end

    end
  end
end
