# -*- encoding: utf-8 -*-
# stub: firewall_egress 0.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "firewall_egress".freeze
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Fernando Arias".freeze, "Matt Buck".freeze, "Samuel Huckins".freeze, "Luke Imhoff".freeze, "David Maloney".freeze, "Lance Sanchez".freeze, "Joe Vennix".freeze]
  s.date = "2023-05-23"
  s.description = "Test firewall egress".freeze
  s.email = ["ferando_arias@rapid7.com".freeze, "matt_buck@rapid7.com".freeze, "samuel_huckins@rapid7.com".freeze, "luke_imhoff@rapid7.com".freeze, "david_maloney@rapid7.com".freeze, "lance_sanchez@rapid7.com".freeze, "joev@metasploit.com".freeze]
  s.homepage = "https://github.com/rapid7/pro/metamodules/firewall_egress".freeze
  s.licenses = ["Proprietary".freeze]
  s.rubygems_version = "3.4.13".freeze
  s.summary = "Test firewall egress".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<activerecord>.freeze, ["~> 7.0"])
  s.add_runtime_dependency(%q<metasploit-concern>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<railties>.freeze, ["~> 7.0"])
end
