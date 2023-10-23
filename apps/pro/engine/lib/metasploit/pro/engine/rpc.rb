require 'pro/tasks'
require 'fileutils'

require "msf/core/rpc/v10/constants"
require "msf/core/rpc/v10/rpc_base"

class Metasploit::Pro::Engine::Rpc < Msf::RPC::RPC_Base

  attr_accessor :tasks

  def initialize(*args)
    super(*args)
    self.tasks = self.service.options[:tasks]
  end

  def rpc_about
    {
      "product" => self.framework.esnecil_product_name,
      "version" => self.framework.esnecil_product_version
    }
  end

  def rpc_workspaces
    ::ApplicationRecord.connection_pool.with_connection {
      r = {}
      Mdm::Workspace.all.each do |w|
        r[w.name] = _workspace_to_hash(w)
      end
      r
    }
  end

  def rpc_projects
    rpc_workspaces
  end


  def rpc_workspace_add(conf)
    ::ApplicationRecord.connection_pool.with_connection do
      r    = {}
      opts = {
        'owner_id'    => _find_rpc_user_id,
        'limit_to_network' => false
      }.merge(conf)
      # XXX: BUG? Should this be opts?
      w = Mdm::Workspace.new(opts)
      if w.save
        r[w.name] = _workspace_to_hash(w)
        r
      else
        error(500, w.errors.full_messages.join(', '))
      end
    end
  end

  def rpc_project_add(conf)
    rpc_workspace_add(conf)
  end


  def rpc_workspace_del(wspace)
    r  = {}
    ::ApplicationRecord.connection_pool.with_connection {
      w  = _find_workspace(wspace)
      w.destroy!
    }
    {'result' => 'success'}
  end

  def rpc_project_del(wspace)
    rpc_workspace_del(wspace)
  end

  def rpc_default_admin_user
    {"username" => _find_rpc_user}
  end


private

  def _find_rpc_user
    ::ApplicationRecord.connection_pool.with_connection {
      Mdm::User.find_by_admin(true).username
    }
  end

  def _find_rpc_user_id
    ::ApplicationRecord.connection_pool.with_connection {
      Mdm::User.find_by_admin(true).id
    }
  end

  def _workspace_to_hash(w)
    ::ApplicationRecord.connection_pool.with_connection {
      r = {}
      r[:created_at] = w.created_at.to_i
      r[:updated_at] = w.updated_at.to_i
      r[:name] = w.name
      r[:boundary] = w.boundary
      r[:description] = w.description
      r[:owner] = Mdm::User.find( w.owner_id ).username rescue _find_rpc_user
      r[:limit_to_network] = w.limit_to_network
      r
    }
  end

  def _find_meterpreter_session(sid)
    s = _find_session(sid)
    if(s.type != "meterpreter")
      error(500, "Session is not of type meterpreter")
    end
    s
  end

  def _find_session(sid)
    s = self.framework.sessions[sid.to_i]
    error(500, "Unknown Session ID") if not s
    s
  end

  def _find_workspace(wspace)
    ::ApplicationRecord.connection_pool.with_connection {
      w = self.framework.db.find_workspace(wspace)
      error(500, "Invalid Project") if not w
      w
    }
  end

  def _base_directory(dtype)
    toplevel = File.expand_path( File.join(File.dirname(__FILE__), '..', '..', '..', '..', '..') )
    case dtype
    when 'loot'
      File.join(toplevel, 'loot')
    when 'report'
      File.join(toplevel, 'reports')
    when 'task'
      File.join(toplevel, 'tasks')
    else
      toplevel
    end
  end

  def _find_module(mname)
    mod = self.framework.modules.create(mname)
    error(500, "Invalid Module") if not mod
    mod
  end

  def _report_loot(opts={})
    host = Mdm::Host.find(opts['host_id'])
    ws = host.workspace
    #generate slightly entropic name
    name =
      Time.now.strftime("%Y%m%d%H%M%S") + "_" + ws.name + "_" +
      (host.name || 'unknown') + '_' + opts['ltype'][0,16] + '_' +
      Rex::Text.rand_text_numeric(6)
    #strip non alphanumeric chars
    name.gsub!(/[^a-z0-9\.\_]+/i, '')
    path = ::File.expand_path(File.join(Msf::Config.loot_directory, name))

    File.open(path, "wb") do |fd|
      fd.write(opts['data'])
    end

    config = {}
    config[:path]         = path
    config[:host]         = host
    config[:workspace]    = ws
    config[:data]         = opts['data']
    config[:info]         = opts['info']
    config[:name]         = opts['name']
    config[:ltype]        = opts['ltype']
    config[:content_type] = opts['content_type']

    loot = self.framework.db.report_loot(config)
    { 'loot_path' => loot.path }
  end

  public

  Metasploit::Concern.run(self)
end
