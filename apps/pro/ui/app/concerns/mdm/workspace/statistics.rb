module Mdm::Workspace::Statistics
  extend ActiveSupport::Concern

  def stats
    Rails.cache.fetch([self,'stats'], expires_in: 5.seconds) do

      res = {
        :loot_count => 0,
        :loot_hosts => {},
        :dead_sess_count => 0,
        :sess_count => 0,
        :sess_hosts => {},
        :pubkey_count => 0,
        :pass_hosts => {},

        :pass_count => 0,
        :hash_count => 0,
        :key_count => 0,
        :credential_cores_count => 0,
        :credential_non_replayable_hashes_count => 0
      }

      loots.includes(:host).each do |ev|
        res[:loot_count] += 1
        if ev.host
          res[:loot_hosts][ev.host.address] = true
        end
      end

      sessions.each do |s|
        thost = s.host.address
        next if not thost or thost == "127.0.0.1"
        thost = thost.split(':')[0]

        res[:sess_count] += 1
        res[:sess_hosts][thost] = true
      end

      res[:dead_sess_count] = sessions.dead.size

      cores = Metasploit::Credential::Core.workspace_id(id).with_public.with_private
      res[:credential_cores_count] =  cores.size

      cores.each do |core|
        if core.private.present?
          case core.private.type
          when Metasploit::Credential::Password.name
            res[:pass_count] += 1
          when Metasploit::Credential::SSHKey.name
            res[:key_count] += 1
          when Metasploit::Credential::NTLMHash.name
            res[:hash_count] += 1
          when Metasploit::Credential::NonreplayableHash.name
            res[:credential_non_replayable_hashes_count] += 1
          end
        end
        core.logins.each do |login|
          host = login.host
          res[:pass_hosts][host.address] = true
        end
      end

      res

    end

  end
end