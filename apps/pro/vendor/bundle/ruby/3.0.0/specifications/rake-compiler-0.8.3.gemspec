# -*- encoding: utf-8 -*-
# stub: rake-compiler 0.8.3 ruby lib

Gem::Specification.new do |s|
  s.name = "rake-compiler".freeze
  s.version = "0.8.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.5".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Luis Lavena".freeze]
  s.date = "2013-02-16"
  s.description = "Provide a standard and simplified way to build and package\nRuby extensions (C, Java) using Rake as glue.".freeze
  s.email = "luislavena@gmail.com".freeze
  s.executables = ["rake-compiler".freeze]
  s.extra_rdoc_files = ["README.rdoc".freeze, "LICENSE.txt".freeze, "History.txt".freeze]
  s.files = ["History.txt".freeze, "LICENSE.txt".freeze, "README.rdoc".freeze, "bin/rake-compiler".freeze]
  s.homepage = "http://github.com/luislavena/rake-compiler".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--main".freeze, "README.rdoc".freeze, "--title".freeze, "rake-compiler -- Documentation".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.6".freeze)
  s.rubygems_version = "3.2.22".freeze
  s.summary = "Rake-based Ruby Extension (C, Java) task generator.".freeze

  s.installed_by_version = "3.2.22" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<rake>.freeze, [">= 0"])
    s.add_development_dependency(%q<rspec>.freeze, ["~> 2.8.0"])
    s.add_development_dependency(%q<cucumber>.freeze, ["~> 1.1.4"])
  else
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 2.8.0"])
    s.add_dependency(%q<cucumber>.freeze, ["~> 1.1.4"])
  end
end
