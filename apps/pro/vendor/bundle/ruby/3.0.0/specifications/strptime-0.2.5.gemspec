# -*- encoding: utf-8 -*-
# stub: strptime 0.2.5 ruby lib
# stub: ext/strptime/extconf.rb

Gem::Specification.new do |s|
  s.name = "strptime".freeze
  s.version = "0.2.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["NARUSE, Yui".freeze]
  s.bindir = "exe".freeze
  s.date = "2020-09-26"
  s.description = "a fast strptime/strftime engine which uses VM.".freeze
  s.email = ["naruse@airemix.jp".freeze]
  s.extensions = ["ext/strptime/extconf.rb".freeze]
  s.files = ["ext/strptime/extconf.rb".freeze]
  s.homepage = "https://github.com/nurse/strptime".freeze
  s.licenses = ["BSD-2-Clause".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0".freeze)
  s.rubygems_version = "3.2.22".freeze
  s.summary = "a fast strptime/strftime engine.".freeze

  s.installed_by_version = "3.2.22" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    s.add_development_dependency(%q<rake-compiler>.freeze, [">= 0"])
    s.add_development_dependency(%q<rake-compiler-dock>.freeze, [">= 0"])
    s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_development_dependency(%q<yard>.freeze, [">= 0"])
  else
    s.add_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rake-compiler>.freeze, [">= 0"])
    s.add_dependency(%q<rake-compiler-dock>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<yard>.freeze, [">= 0"])
  end
end
