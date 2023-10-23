# -*- encoding: utf-8 -*-
# stub: win32-api 1.10.1 ruby lib
# stub: ext/extconf.rb

Gem::Specification.new do |s|
  s.name = "win32-api".freeze
  s.version = "1.10.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Daniel J. Berger".freeze, "Park Heesob".freeze, "Hiroshi Hatake".freeze]
  s.date = "2021-04-23"
  s.description = "    The Win32::API library is meant as a replacement for the Win32API\n    library that ships as part of the standard library. It contains several\n    advantages over Win32API, including callback support, raw function\n    pointers, an additional string type, and more.\n".freeze
  s.email = "djberg96@gmail.com".freeze
  s.extensions = ["ext/extconf.rb".freeze]
  s.extra_rdoc_files = ["CHANGES".freeze, "MANIFEST".freeze, "ext/win32/api.c".freeze]
  s.files = ["CHANGES".freeze, "MANIFEST".freeze, "ext/extconf.rb".freeze, "ext/win32/api.c".freeze]
  s.homepage = "http://github.com/cosmo0920/win32-api".freeze
  s.licenses = ["Artistic-2.0".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.2".freeze)
  s.rubygems_version = "3.2.22".freeze
  s.summary = "A superior replacement for Win32API".freeze

  s.installed_by_version = "3.2.22" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<test-unit>.freeze, [">= 2.5.0"])
    s.add_development_dependency(%q<rake>.freeze, [">= 0"])
  else
    s.add_dependency(%q<test-unit>.freeze, [">= 2.5.0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
  end
end
