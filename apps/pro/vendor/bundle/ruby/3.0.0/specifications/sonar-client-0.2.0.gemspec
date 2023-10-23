# -*- encoding: utf-8 -*-
# stub: sonar-client 0.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "sonar-client".freeze
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Paul Deardorff & HD Moore".freeze]
  s.date = "2022-08-31"
  s.description = "API Wrapper for Sonar".freeze
  s.email = ["paul_deardorff@rapid7.com".freeze, "hd_moore@rapid7.com".freeze]
  s.executables = ["sonar".freeze]
  s.files = ["bin/sonar".freeze]
  s.homepage = "https://sonar.labs.rapid7.com".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.2.22".freeze
  s.summary = "API Wrapper for Sonar".freeze

  s.installed_by_version = "3.2.22" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<faraday>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<faraday-rashify>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<rash_alt>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<faraday-follow_redirects>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<hashie>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<multi_json>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<thor>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<awesome_print>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<table_print>.freeze, [">= 0"])
    s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_development_dependency(%q<simplecov>.freeze, [">= 0"])
    s.add_development_dependency(%q<simplecov-rcov>.freeze, [">= 0"])
    s.add_development_dependency(%q<yard>.freeze, [">= 0"])
    s.add_development_dependency(%q<vcr>.freeze, [">= 0"])
    s.add_development_dependency(%q<shoulda>.freeze, [">= 0"])
    s.add_development_dependency(%q<api_matchers>.freeze, [">= 0"])
  else
    s.add_dependency(%q<faraday>.freeze, [">= 0"])
    s.add_dependency(%q<faraday-rashify>.freeze, [">= 0"])
    s.add_dependency(%q<rash_alt>.freeze, [">= 0"])
    s.add_dependency(%q<faraday-follow_redirects>.freeze, [">= 0"])
    s.add_dependency(%q<hashie>.freeze, [">= 0"])
    s.add_dependency(%q<multi_json>.freeze, [">= 0"])
    s.add_dependency(%q<thor>.freeze, [">= 0"])
    s.add_dependency(%q<awesome_print>.freeze, [">= 0"])
    s.add_dependency(%q<table_print>.freeze, [">= 0"])
    s.add_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<simplecov>.freeze, [">= 0"])
    s.add_dependency(%q<simplecov-rcov>.freeze, [">= 0"])
    s.add_dependency(%q<yard>.freeze, [">= 0"])
    s.add_dependency(%q<vcr>.freeze, [">= 0"])
    s.add_dependency(%q<shoulda>.freeze, [">= 0"])
    s.add_dependency(%q<api_matchers>.freeze, [">= 0"])
  end
end
