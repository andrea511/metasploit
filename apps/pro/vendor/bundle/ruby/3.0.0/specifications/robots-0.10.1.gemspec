# -*- encoding: utf-8 -*-
# stub: robots 0.10.1 ruby lib

Gem::Specification.new do |s|
  s.name = "robots".freeze
  s.version = "0.10.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Kyle Maxwell".freeze]
  s.date = "2011-04-12"
  s.description = "It parses robots.txt files".freeze
  s.email = "kyle@kylemaxwell.com".freeze
  s.extra_rdoc_files = ["README".freeze]
  s.files = ["README".freeze]
  s.homepage = "http://github.com/fizx/robots".freeze
  s.rdoc_options = ["--charset=UTF-8".freeze]
  s.rubygems_version = "3.2.22".freeze
  s.summary = "Simple robots.txt parser".freeze

  s.installed_by_version = "3.2.22" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<thoughtbot-shoulda>.freeze, [">= 0"])
  else
    s.add_dependency(%q<thoughtbot-shoulda>.freeze, [">= 0"])
  end
end
