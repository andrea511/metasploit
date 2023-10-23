module Metasploit::Pro::Engine::Rpc::Updates

  def rpc_license
    self.framework.esnecil_information
  end

  def rpc_register(pkey)
    self.framework.esnecil_register(pkey)
  end

  def rpc_revert_license
    self.framework.esnecil_revert_license()
  end

  def rpc_activate(conf={})
    self.framework.esnecil_activate(conf)
  end

  def rpc_activate_offline(path)
    self.framework.esnecil_activate_offline(path)
  end

  def rpc_update_available(conf={})
    self.framework.esnecil_update_available?(conf)
  end

  def rpc_update_install(conf)
    self.framework.esnecil_update_install(conf)
  end

  def rpc_update_install_offline(path)
    self.framework.esnecil_update_install_offline(path)
  end

  def rpc_update_status(conf={})
    self.framework.esnecil_update_status(conf)
  end

  def rpc_update_stop(conf={})
    self.framework.esnecil_update_stop(conf)
  end

  def rpc_restart_service(conf={})
    self.framework.esnecil_restart_service(conf)
  end

  def rpc_usage_metrics_update(data, conf={})
    self.framework.esnecil_usage_metrics_update(data, conf)
  end

  def rpc_restart_status(conf={})
    self.framework.esnecil_restart_status(conf)
  end
end
