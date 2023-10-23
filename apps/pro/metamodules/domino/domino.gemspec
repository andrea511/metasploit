# -*- encoding: utf-8 -*-
# stub: domino 0.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "domino".freeze
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Joe Vennix".freeze]
  s.date = "2023-05-23"
  s.description = "Credentials domino is the king, all hail".freeze
  s.email = ["joev@metasploit.com".freeze]
  s.homepage = "https://github.com/rapid7/pro/metamodules/domino".freeze
  s.licenses = ["Proprietary".freeze]
  s.rubygems_version = "3.4.13".freeze
  s.summary = "Credential domino is the boss".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<activerecord>.freeze, ["~> 7.0"])
  s.add_runtime_dependency(%q<metasploit-concern>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<railties>.freeze, ["~> 7.0"])
end
