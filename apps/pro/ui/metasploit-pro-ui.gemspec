# -*- encoding: utf-8 -*-
# stub: metasploit-pro-ui 0.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "metasploit-pro-ui".freeze
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Brandon Turner".freeze, "Chris Doughty".freeze, "David Maloney".freeze, "Fernando Arias".freeze, "Gavin Schneider".freeze, "HD Moore".freeze, "James Lee".freeze, "Joe Vennix".freeze, "Kyle Gray".freeze, "Lance Sanchez".freeze, "Luke Imhoff".freeze, "Matt Buck".freeze, "Samuel Huckins".freeze, "Thao Doan".freeze, "Tod Beardsley".freeze, "Trevor Rosen".freeze]
  s.date = "2023-05-23"
  s.description = "Metasploit Pro UI".freeze
  s.email = ["brandon_turner@rapid7.com".freeze, "chris_doughty@rapid7.com".freeze, "david_maloney@rapid7.com".freeze, "fernando_arias@rapid7.com".freeze, "gavin_schneider@rapid7.com".freeze, "hd_moore@rapid7.com".freeze, "james_lee@rapid7.com".freeze, "joe_vennix@rapid7.com".freeze, "kyle_gray@rapid7.com".freeze, "lance_sanchez@rapid7.com".freeze, "luke_imhoff@rapid7.com".freeze, "matt_buck@rapid7.com".freeze, "samuel_huckins@rapid7.com".freeze, "thao_doan@rapid7.com".freeze, "tod_beardsley@rapid7.com".freeze, "trevor_rosen@rapid7.com".freeze]
  s.homepage = "https://github.com/rapid7/pro/ui".freeze
  s.licenses = ["Proprietary".freeze]
  s.rubygems_version = "3.4.13".freeze
  s.summary = "Metasploit Pro UI".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<activerecord>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<acts_as_list>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<after_commit_queue>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<authlogic>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<carrierwave>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<cookiejar>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<delayed_job>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<delayed_job_active_record>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<formtastic>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<has_scope>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<ice_cube>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<liquid>.freeze, ["= 2.6.2"])
  s.add_runtime_dependency(%q<metasploit-concern>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<metasploit-credential>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<metasploit_data_models>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<metasploit-framework>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<ohai>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<win32-process>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<ffi-win32-extensions>.freeze, ["= 1.0.4"])
  s.add_runtime_dependency(%q<pg>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<rake-compiler>.freeze, ["< 0.9"])
  s.add_runtime_dependency(%q<rake>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<rubyzip>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<state_machines-activerecord>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<wicked>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<domino>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<firewall_egress>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<network_interface>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<pcaprub>.freeze, [">= 0"])
end
