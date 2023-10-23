# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :firewall_egress_result_range, class: Apps::FirewallEgress::ResultRange do
    start_port{3000}
    end_port{3005}
    state { "open" }
    target_host { "10.6.2.99" }
  end
end
