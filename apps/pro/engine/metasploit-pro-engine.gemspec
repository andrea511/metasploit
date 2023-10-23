# -*- encoding: utf-8 -*-
# stub: metasploit-pro-engine 0.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "metasploit-pro-engine".freeze
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Brandon Turner".freeze, "David Maloney".freeze, "Fernando Arias".freeze, "HD Moore".freeze, "James Lee".freeze, "Joe Vennix".freeze, "Lance Sanchez".freeze, "Luke Imhoff".freeze, "Matt Buck".freeze, "Samuel Huckins".freeze, "Tod Beardsley".freeze, "Trevor Rosen".freeze]
  s.date = "2023-05-23"
  s.description = "Background engine that runs `prosvc` for Metasploit Pro".freeze
  s.email = ["brandon_turner@rapid7.com".freeze, "david_maloney@rapid7.com".freeze, "hd_moore@rapid7.com".freeze, "james_lee@rapid7.com".freeze, "joe_vennix@rapid7.com".freeze, "lance_sanchez@rapid7.com".freeze, "luke_imhoff@rapid7.com".freeze, "matt_buck@rapid7.com".freeze, "samuel_huckins@rapid7.com".freeze, "tod_beardsley@rapid7.com".freeze, "trevor_rosen@rapid7.com".freeze]
  s.homepage = "https://github.com/rapid7/pro/engine".freeze
  s.licenses = ["Proprietary".freeze]
  s.rubygems_version = "3.4.13".freeze
  s.summary = "Background engine for Metasploit Pro".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<actionpack>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<ffi>.freeze, ["~> 1.9"])
  s.add_runtime_dependency(%q<metasploit-concern>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<metasploit-framework>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<metasploit-pro-ui>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<rbnacl>.freeze, ["< 5.0.0"])
  s.add_runtime_dependency(%q<ruby-progressbar>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<domino>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<firewall_egress>.freeze, [">= 0"])
end
