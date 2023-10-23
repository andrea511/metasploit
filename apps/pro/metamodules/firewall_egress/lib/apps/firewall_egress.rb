# Entry-point for requiring this engine.

# Declare the Apps::FirewallEgress namespace
module Apps; module FirewallEgress; end; end

# Load the actual engine
require 'apps/firewall_egress/engine'
