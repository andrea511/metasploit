module Metasploit::Pro::Engine::Rpc::Domino

  def rpc_start_domino_metamodule(conf={})
    _start_module_task(conf, "metamodule/domino", "Credentials Domino")
  end

end
