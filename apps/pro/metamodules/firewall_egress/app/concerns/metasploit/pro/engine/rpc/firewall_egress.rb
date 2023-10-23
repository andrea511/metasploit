module Metasploit::Pro::Engine::Rpc::FirewallEgress

  def rpc_start_firewall_egress_testing(conf={})
    _start_module_task(conf, "metamodule/firewall_egress", "Segmentation and Firewall Testing")
  end

end
