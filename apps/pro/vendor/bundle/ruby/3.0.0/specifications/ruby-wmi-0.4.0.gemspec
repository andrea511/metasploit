# -*- encoding: utf-8 -*-
# stub: ruby-wmi 0.4.0 ruby lib

Gem::Specification.new do |s|
  s.name = "ruby-wmi".freeze
  s.version = "0.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Gordon Thiesfeld".freeze, "Jamie Winsor".freeze]
  s.date = "2012-03-30"
  s.description = "ruby-wmi is an ActiveRecord style interface for Microsoft's Windows Management Instrumentation provider.".freeze
  s.email = ["gthiesfeld@gmail.com".freeze, "jwinsor@riotgames.com".freeze]
  s.homepage = "https://github.com/vertiginous/ruby-wmi".freeze
  s.rubygems_version = "3.2.22".freeze
  s.summary = "ruby-wmi is an ActiveRecord style interface for Microsoft's Windows Management Instrumentation provider.".freeze

  s.installed_by_version = "3.2.22" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_development_dependency(%q<thor>.freeze, [">= 0"])
  else
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<thor>.freeze, [">= 0"])
  end
end
