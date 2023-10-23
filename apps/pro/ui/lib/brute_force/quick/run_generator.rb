require 'metasploit/pro/engine/credential/defaults'
require 'memoist'
module BruteForce
  module Quick

    # This Class takes input from the Quick BruteForce form and the TargetSelector and
    # generates a {BruteForce::Run} object and it's associated {BruteForce::Guess::Attempt}s
    class RunGenerator
      extend Memoist
      include Metasploit::Credential::Creation

      # @!attribute :bruteforce_run
      #   @return [BruteForce::Run] the Bruteforce Run
      attr_accessor :bruteforce_run
      # @!attribute :config
      #   @return [Hash] the config options for the BruteForce::Run
      attr_accessor :cred_options
      # @!attribute :target_service
      #   @return [ActiveRecord::Relation] the relation containing the target {Mdm::Service}s from the {Bruteforce::Quick::TargetSelector}
      attr_accessor :target_services
      # @!attribute :workspace
      #   @return [Mdm::Workspace] the {Mdm::Workspace} we are working in
      attr_accessor :workspace

      # @param attributes [Hash{Symbol => String,nil}]
      def initialize(attributes={})
        attributes.each do |attribute, value|
          public_send("#{attribute}=", value)
        end
      end

      # Goes through the target services and finds any known factory
      # default creds for that service and creates Attempts for each
      # default cred for that service.
      # @return [Array<BruteForce::Guess::Attempt>]
      def attempts_from_defaults
        attempts = []
        target_services.each do |service|
          cred_set  = Metasploit::Pro::Engine::Credential::Defaults.default_creds_for_service(service)
          cred_set.each do |credential|
            guess_core = guess_core_from_credential(credential)
            attempts << BruteForce::Guess::Attempt.where(
              brute_force_run_id: bruteforce_run.id,
              brute_force_guess_core_id: guess_core.id,
              service_id: service.id
            ).first_or_create!
          end
        end
        attempts
      end


      # Takes the user supplied input from the form and returns all of the
      # attempts for that input.
      #
      # @return [Array<BruteForce::Guess::Attempt>] the attempts for the improted cred pairs
      def attempts_from_input
        attempts = []
        cred_strings = cred_options["import_cred_pairs"]["data"].gsub(/\r/,'')
        cred_strings.each_line do |cred_string|
          attempts += attempts_from_string(cred_string,cred_options["import_cred_pairs"]["blank_as_password"],cred_options["import_cred_pairs"]["username_as_password"]  )
        end
        attempts
      end

      # Takes a single line of string input from the form and returns
      # a set of {BruteForce::Guess::Attempt} objects.
      #
      # @param :cred_string [String] the manual credential input line
      # @param :blank [Boolean] whether or not to try the public with a blank password
      # @param :username [Boolean] whether or not to try the public with the public also set as the password
      # @return [Array<BruteForce::Guess::Attempt>] the attempts to be made based on that input string
      def attempts_from_string(cred_string, blank=false, username=false)
        attempts = []
        cores = guess_cores_from_string(cred_string, blank, username)
        cores.each do |guess_core|
          target_services.each do |service|
            guess_attempt = BruteForce::Guess::Attempt.where(
              brute_force_run_id: bruteforce_run.id,
              brute_force_guess_core_id: guess_core.id,
              service_id: service.id
            ).first_or_create!
            attempts << guess_attempt
          end
        end
        attempts
      end

      # Returns an array of {BruteForce::Guess::Attempt}s for each {Metasploit::Credential::Core} in the
      # current {Mdm::Workspace}, attached to the generated {BruteForce::Run}.
      #
      # @return [Array<BruteForce::Guess::Attempt] an array of attempts created from existing creds
      def attempts_from_workspace_creds
        attempts = []
        guess_cores_from_workspace_creds do |guess_core|
          target_services.each do |service|
            guess_attempt = BruteForce::Guess::Attempt.where(
              brute_force_run_id: bruteforce_run.id,
              brute_force_guess_core_id: guess_core.id,
              service_id: service.id
            ).first_or_create!
            attempts << guess_attempt
          end
        end
        attempts
      end

      #parse a line of multiple passwords, a password can have space, but it's wrapped in ""
      #assume password doesn't allow double quote char
      def parsePasswords (str)
         ret = []
         while str.length > 0
            if str =~ /^\s+(.*)/
               str = $1
               if str.length == 0
                  return ret
               end
            end
            if str[0] == "\""
               str =~ /^\"([^\"]+)\"(.*)/
               ret.push($1)
               str = $2
            elsif str =~ /^(\S+)(.*)/
               ret.push($1)
               str = $2
            end
         end
         return ret
      end


      # Takes the remaining cred line and yields out a
      # {Metasploit::Credential::Password} for each word
      # still left on the line.
      #
      # @param :cred_string [String] the line from the manual entry box
      # @yieldparam :private_object [Metasploit::Credential::Public]
      # @return [void] no useable return value here
      def each_private_from_string(cred_string)
        #privates = cred_string.split(/\s+/)
        privates = parsePasswords(cred_string)
        privates.each do |password|
          next if password.blank?
          private_object = create_credential_private(
            private_data: password,
            private_type: :password
          )
          yield private_object
        end
      end

      # Responsible for taking all of the attributes on the object
      # and generating a {BruteForce::Run} and the associated
      # {BruteForce::Guess::Attempt}s
      #
      # @return [BruteForce::Run]
      def generate_run
        attempts = []

        # Create Attempts for all existing creds in the workspace
        if cred_options["import_workspace_creds"] == true
          workspace_attemmpts = attempts_from_workspace_creds
          attempts += workspace_attemmpts
        end

        # get attempts for all factory defaults for the target services
        if cred_options["factory_defaults"] == true
          default_attempts = attempts_from_defaults
          attempts += default_attempts
        end

        # process attempts from the user input/uploaded file
        input_attempts = attempts_from_input
        attempts += input_attempts

        #return the Bruteforce::Run which should now be associated to all of the attempts
        bruteforce_run
      end

      # Takes a {Metasploit::Framework::Credential} and generates a
      # {Bruteforce::Guess::Core} from it.
      #
      # @param :credential [Metasploit::Framework::Credential] the framework credential object
      # @return [BruteForce::Guess::Core]
      def guess_core_from_credential(credential)
        public = create_credential_public(
          username: credential.public
        )
        private = create_credential_private(
          private_data: credential.private,
          private_type: :password
        )
        BruteForce::Guess::Core.where(
          public_id: public.try(:id),
          private_id: private.try(:id),
          workspace_id: workspace.id
        ).first_or_create!
      end

      # Takes a single line from the manual entry box, or uplaoded file
      # and creates {BruteForce::Guess::Core} objects based on the selected
      # options.
      #
      # @param :cred_string [String] the input line to process
      # @param :blank [Boolean] whether or not to try the public with a blank password
      # @param :username [Boolean] whether or not to try the public with the public also set as the password
      # @return [Array<BruteForce::Guess::Core>] the Guess Cores to make attempts from
      def guess_cores_from_string(cred_string, blank=false, username=false)
        guess_cores = []

        realm_object = realm_from_string(cred_string)
        public_object = public_from_string(cred_string)

        each_private_from_string(cred_string) do |private_object|
          guess_core =  BruteForce::Guess::Core.where(
            public_id: public_object.try(:id),
            private_id: private_object.try(:id),
            realm_id: realm_object.try(:id),
            workspace_id: workspace.id
          ).first_or_create!
          guess_cores << guess_core
        end

        # If Blank password was selected, take all of the other components
        # and create a guess core with a blank password.
        if blank
          private_object = Metasploit::Credential::BlankPassword.where(data:'').first_or_create!
          guess_core =  BruteForce::Guess::Core.where(
            public_id: public_object.try(:id),
            private_id: private_object.try(:id),
            realm_id: realm_object.try(:id),
            workspace_id: workspace.id
          ).first_or_create!
          guess_cores << guess_core
        end

        # If the Username as password option was selected create a Private
        # with the same value as the public, and make a new Guess core.
        if username
          private_object = create_credential_private(
            private_data: public_object.username,
            private_type: :password
          )
          guess_core =  BruteForce::Guess::Core.where(
            public_id: public_object.try(:id),
            private_id: private_object.try(:id),
            realm_id: realm_object.try(:id),
            workspace_id: workspace.id
          ).first_or_create!
          guess_cores << guess_core
        end

        guess_cores
      end

      # Yields a {BruteForce::Guess::Core} for each {Metasploit::Credential::Core}
      # found in the {Mdm::Workspace}.
      #
      # @yieldparam :guess_core [BruteForce::Guess::Core] the Guess Core to use
      # @return [void] Do not depend on a return value here
      def guess_cores_from_workspace_creds
        workspace_creds.each do |cred|
          guess_core =  BruteForce::Guess::Core.where(
            public_id: cred.public_id,
            private_id: cred.private_id,
            realm_id: cred.realm_id,
            workspace_id: workspace.id
          ).first_or_create!
          yield guess_core
        end
      end

      # Processes a line from the manual credential entry field
      # and finds the public credential and creates an actual
      # {Metasploit::Credential::Public} object.
      #
      # @param :cred_string [String] the line from the manual entry box
      # @return [Metasploit::Credential::Public] if a public was found in the string
      # @return [nilClass] if no public was found
      def public_from_string(cred_string)
        public = cred_string.slice!(/^\S+/)
        if public
          public_object = create_credential_public(
            username: public
          )
        else
          public_object = nil
        end
        public_object
      end

      # Takes a credential string currently being processed and strips
      # off any realm at the front, and creates a {Metasploit::Credential::Realm}
      # for it.
      #
      # @param :cred_string [String] the line currently being processed from the manual creds field
      # @return [Metasploit::Credential::Realm] if a realm was found and created
      # @return [nilClass] if no realm was found.
      def realm_from_string(cred_string)
        realm = cred_string.slice!(/^\w+\\/)
        if realm
          realm.gsub!(/\\/,'')
          realm_object = create_credential_realm(
            realm_key: Metasploit::Model::Realm::Key::WILDCARD ,
            realm_value: realm
          )
        else
          realm_object = nil
        end
        realm_object
      end

      # Finds all {Metasploit::Credential::Core}s in the workspace
      #
      # @return [ActiveRecord::Relation] the matching Credential Cores
      def workspace_creds
        Metasploit::Credential::Core.where(workspace_id: workspace.id)
      end
      memoize :workspace_creds

      private

    end
  end
end
