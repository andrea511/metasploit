module Metasploit
  module Pro
    module Engine
      module Credential
        module Defaults

          # This is the base class for all default credential sets used by Pro.
          class CredentialSet

            # The default usernames to try
            USERNAMES = [
              'admin',
              'administrator',
              'root'
            ].freeze

            # The default passwords to try
            PASSWORDS = [
              '1234',
              'admin',
              'changeme123',
              'password',
              'password1',
              'password123',
              'password123!',
              'toor'
            ].freeze

            # 2-dimensional array containing all combinations of {USERNAMES} and {PASSWORDS}
            COMBINATIONS = USERNAMES.product(PASSWORDS).uniq.freeze

            # A count of all the combinations held in {COMBINATIONS}
            COUNT = COMBINATIONS.count.freeze

            # Whether the credential requires both a Public and Private to be valid
            PAIRED = true

            # This method takes a block and yields back a `Metasploit::Framework::Credential` for
            # each credential pair specified by COMBINATIONS.
            #
            # @yieldparam [Metasploit::Framework::Credential] a default credential for this service type
            # @return [void]
            def each
              self.class::COMBINATIONS.each do |combo|
                cred = Metasploit::Framework::Credential.new(public: combo[0], private: combo[1], realm: nil, private_type: :password, paired: self.class::PAIRED)
                yield cred
              end
            end

          end
        end
      end
    end
  end
end
