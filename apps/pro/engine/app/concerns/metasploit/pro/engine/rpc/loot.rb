module Metasploit::Pro::Engine::Rpc::Loot

  def rpc_loot_create(opts={})
    _report_loot(opts)
  end

  # Delete the data file associated with a Loot record
  def rpc_loot_delete_file(loot_id)
    r = _find_loot(loot_id)

    ::FileUtils.rm_f(r.path)

    { 'status' => 'success'}
  end

  # List all Loot in a particular workspace
  def rpc_loot_list(wspace)
    w = _find_workspace(wspace)
    r = {}
    w.loots.each do |l|
      r[l.id] = _loot_to_hash(l)
    end

    r
  end

  # Download the raw data corresponding to a Loot record
  def rpc_loot_download(loot_id)
    l = _find_loot(loot_id)
    r = _loot_to_hash(l)
    r[:data] = l.data || ''

    if l.path and ::File.exist?(l.path)
      ::File.open(l.path, "rb") do |fd|
        r[:data] << fd.read(fd.stat.size)
      end
    end

    r
  end

private

  def _loot_to_hash(l)
    loot = {}
    loot[:workspace] = l.workspace.name
    loot[:host] = l.host.address if l.host
    loot[:service] = l.service.port if l.service
    loot[:proto] = l.service.proto if l.service
    loot[:ltype] = l.ltype
    loot[:ctype] = l.content_type
    loot[:created_at] = l.created_at.to_i
    loot[:updated_at] = l.updated_at.to_i
    loot[:name] = l.name
    loot[:info] = l.info
    loot[:path] = l.path

    # XXX: Size ignores l.data, which should not be used anymore
    loot[:size] = ::File.size(l.path) rescue 0

    loot
  end

  def _find_loot(loot_id)
    ::ApplicationRecord.connection_pool.with_connection {
      r = ::Mdm::Loot.find(loot_id.to_i)
      error(500, "Invalid Loot ID") if not r
      r
    }
  end

end
