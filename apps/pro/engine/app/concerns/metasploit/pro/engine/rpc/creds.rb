module Metasploit::Pro::Engine::Rpc::Creds

  # List all credentials in a particular workspace
  def rpc_cred_list(wspace)
    w = _find_workspace(wspace)
    r = {}

    ::ApplicationRecord.connection_pool.with_connection {
      w.creds.each do |c|
        r[c.id] = _cred_to_hash(c)
      end
    }

    r
  end

  # Delete a specific credential from the database
  def rpc_cred_delete(cred_id)
    r = _find_cred(cred_id)
    ::ApplicationRecord.connection_pool.with_connection { r.destroy }

    { 'status' => 'success'}
  end

private

  def _cred_to_hash(c)
    cred = {}
    cred[:workspace] = c.workspace.name
    cred[:created_at] = c.created_at.to_i
    cred[:updated_at] = c.updated_at.to_i

    ::ApplicationRecord.connection_pool.with_connection {
      if c.service
        cred[:service] = c.service.port
        if c.service.host
          cred[:host] = c.service.host.address
        end
      end
    }

    cred[:user]   = c.user
    cred[:pass]   = c.pass
    cred[:active] = c.active
    cred[:proof]  = c.proof
    cred[:ptype]  = c.ptype
    cred[:source_type] = c.source_type
    cred[:source_id]   = c.source_id

    cred
  end

  def _find_cred(cred_id)
    ::ApplicationRecord.connection_pool.with_connection {
      r = ::Mdm::Loot.find(cred_id.to_i)
      error(500, "Invalid Credential ID") if not r
      r
    }
  end

end
