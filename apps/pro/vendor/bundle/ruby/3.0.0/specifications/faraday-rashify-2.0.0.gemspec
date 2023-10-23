# -*- encoding: utf-8 -*-
# stub: faraday-rashify 2.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "faraday-rashify".freeze
  s.version = "2.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "homepage_uri" => "https://github.com/lostisland/faraday-rashify", "source_code_uri" => "https://github.com/lostisland/faraday-rashify" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Olle Jonsson".freeze]
  s.date = "2022-03-09"
  s.description = "This middleware was extracted from faraday_middleware.".freeze
  s.email = ["olle.jonsson@gmail.com".freeze]
  s.homepage = "https://github.com/lostisland/faraday-rashify".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.6".freeze)
  s.rubygems_version = "3.2.22".freeze
  s.summary = "A Faraday middleware around rash_alt.".freeze

  s.installed_by_version = "3.2.22" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<faraday>.freeze, [">= 2.0"])
  else
    s.add_dependency(%q<faraday>.freeze, [">= 2.0"])
  end
end
