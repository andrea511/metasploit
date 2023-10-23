# -*- encoding: utf-8 -*-
# stub: after_commit_queue 1.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "after_commit_queue".freeze
  s.version = "1.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Grzegorz Ko\u0142odziejczyk".freeze, "Mariusz Pietrzyk".freeze]
  s.date = "2015-10-05"
  s.description = "Plugin for running methods on ActiveRecord models after record is committed".freeze
  s.email = ["devs@shellycloud.com".freeze]
  s.homepage = "https://github.com/shellycloud/after_commit_queue".freeze
  s.rubygems_version = "3.2.22".freeze
  s.summary = "after_commit queue".freeze

  s.installed_by_version = "3.2.22" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<activerecord>.freeze, [">= 3.0"])
    s.add_development_dependency(%q<sqlite3>.freeze, [">= 0"])
    s.add_development_dependency(%q<rails>.freeze, [">= 3.0"])
  else
    s.add_dependency(%q<activerecord>.freeze, [">= 3.0"])
    s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
    s.add_dependency(%q<rails>.freeze, [">= 3.0"])
  end
end
