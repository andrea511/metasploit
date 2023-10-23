require 'sshkey'

class TranslateSshSessions < ActiveRecord::Migration[5.2]
  def up
    Mdm::Session.where(via_exploit: 'auxiliary/pro/scanner/ssh/ssh_login_credential').find_each do |ssh_session|
      begin
        datastore = ssh_session.datastore.clone

        cred_core_id = datastore['CRED_CORE_ID']
        cred_core_private_id = Metasploit::Credential::Core.find(cred_core_id).private_id
        private_type = Metasploit::Credential::Private.find(cred_core_private_id).type

        datastore.delete('CRED_CORE_ID')

        case private_type
        when "Metasploit::Credential::Password"
          ssh_session.via_exploit = "auxiliary/scanner/ssh/ssh_login"
          ssh_session.datastore = datastore
        when "Metasploit::Credential::SSHKey"
          # When session replay retrieves the datastore, new line characters aren't deserialized so going to
          # use the Credential Core private ID so that the correct private key can be retrieved again
          datastore['CRED_CORE_PRIVATE_ID'] = cred_core_private_id
          ssh_session.desc = session_description_clean_up(datastore)
          ssh_session.via_exploit = "auxiliary/scanner/ssh/ssh_login_pubkey"

          datastore.delete('PASSWORD')
          ssh_session.datastore = datastore
        end

        ssh_session.save
      rescue ActiveRecord::RecordNotFound, OpenSSL::PKey::PKeyError
        next
      end
    end
  end

  def down
  end

  # Consolidating the session description so it doesn't show the full private key making the
  # sessions page cluttered.
  def session_description_clean_up(datastore)
    private_key = datastore['PASSWORD']
    rsa_key = Net::SSH::KeyFactory.load_data_private_key(private_key).to_s
    ssh_key = SSHKey.new rsa_key
    fingerprint = ssh_key.fingerprint
    "SSH #{datastore['USERNAME']}:#{fingerprint} (#{datastore['RHOST']}:#{datastore['RPORT']})"
  end
end
