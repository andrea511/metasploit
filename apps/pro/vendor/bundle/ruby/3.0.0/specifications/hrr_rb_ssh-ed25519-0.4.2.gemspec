# -*- encoding: utf-8 -*-
# stub: hrr_rb_ssh-ed25519 0.4.2 ruby lib

Gem::Specification.new do |s|
  s.name = "hrr_rb_ssh-ed25519".freeze
  s.version = "0.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "homepage_uri" => "https://github.com/hirura/hrr_rb_ssh-ed25519", "source_code_uri" => "https://github.com/hirura/hrr_rb_ssh-ed25519" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["hirura".freeze]
  s.date = "2020-01-20"
  s.description = "hrr_rb_ssh extension that supports ED25519 public key algorithm.".freeze
  s.email = ["hirura@gmail.com".freeze]
  s.homepage = "https://github.com/hirura/hrr_rb_ssh-ed25519".freeze
  s.required_ruby_version = Gem::Requirement.new(">= 2.0.0".freeze)
  s.rubygems_version = "3.2.22".freeze
  s.summary = "hrr_rb_ssh extension that supports ED25519 public key algorithm.".freeze

  s.installed_by_version = "3.2.22" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<hrr_rb_ssh>.freeze, [">= 0.4"])
    s.add_runtime_dependency(%q<ed25519>.freeze, ["~> 1.2"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 12.0"])
    s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.16"])
  else
    s.add_dependency(%q<hrr_rb_ssh>.freeze, [">= 0.4"])
    s.add_dependency(%q<ed25519>.freeze, ["~> 1.2"])
    s.add_dependency(%q<rake>.freeze, ["~> 12.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_dependency(%q<simplecov>.freeze, ["~> 0.16"])
  end
end
