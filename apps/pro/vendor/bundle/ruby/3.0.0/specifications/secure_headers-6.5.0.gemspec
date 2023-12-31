# -*- encoding: utf-8 -*-
# stub: secure_headers 6.5.0 ruby lib

Gem::Specification.new do |s|
  s.name = "secure_headers".freeze
  s.version = "6.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Neil Matatall".freeze]
  s.date = "2022-10-25"
  s.description = "Add easily configured security headers to responses\n    including content-security-policy, x-frame-options,\n    strict-transport-security, etc.".freeze
  s.email = ["neil.matatall@gmail.com".freeze]
  s.homepage = "https://github.com/twitter/secureheaders".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.2.22".freeze
  s.summary = "Manages application of security headers with many safe defaults.".freeze

  s.installed_by_version = "3.2.22" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<rake>.freeze, [">= 0"])
  else
    s.add_dependency(%q<rake>.freeze, [">= 0"])
  end
end
