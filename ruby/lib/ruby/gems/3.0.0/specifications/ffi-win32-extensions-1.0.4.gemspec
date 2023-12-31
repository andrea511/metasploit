# -*- encoding: utf-8 -*-
# stub: ffi-win32-extensions 1.0.4 ruby lib

Gem::Specification.new do |s|
  s.name = "ffi-win32-extensions".freeze
  s.version = "1.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Daniel J. Berger".freeze]
  s.date = "2020-09-09"
  s.description = "    The ffi-win32-extensions library adds additional methods to the FFI\n    and String classes to aid in the development of FFI based libraries\n    on MS Windows.\n".freeze
  s.email = "djberg96@gmail.com".freeze
  s.homepage = "http://github.com/chef/ffi-win32-extensions".freeze
  s.licenses = ["Apache 2.0".freeze]
  s.rubygems_version = "3.2.22".freeze
  s.summary = "Extends the FFI and String classes on MS Windows".freeze

  s.installed_by_version = "3.2.22" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<ffi>.freeze, [">= 0"])
  else
    s.add_dependency(%q<ffi>.freeze, [">= 0"])
  end
end
