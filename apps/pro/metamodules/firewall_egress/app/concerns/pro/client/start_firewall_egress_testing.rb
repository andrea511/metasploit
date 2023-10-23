module Pro::Client::StartFirewallEgressTesting
  def start_firewall_egress_testing(conf)
    call("pro.start_firewall_egress_testing", conf)
  end
end
