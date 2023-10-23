# -*- encoding: utf-8 -*-
# stub: rake-compiler-dock 0.7.2 ruby lib

Gem::Specification.new do |s|
  s.name = "rake-compiler-dock".freeze
  s.version = "0.7.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Lars Kanis".freeze]
  s.date = "2019-03-18"
  s.description = "Easy to use and reliable cross compiler environment for building Windows and Linux binary gems.\nUse rake-compiler-dock to enter an interactive shell session or add a task to your Rakefile to automate your cross build.".freeze
  s.email = ["lars@greiz-reinsdorf.de".freeze]
  s.executables = ["rake-compiler-dock".freeze]
  s.files = ["bin/rake-compiler-dock".freeze]
  s.homepage = "https://github.com/rake-compiler/rake-compiler-dock".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.6.2".freeze
  s.summary = "Easy to use and reliable cross compiler environment for building Windows and Linux binary gems.".freeze

  s.installed_by_version = "2.7.6.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.7"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 12.0"])
      s.add_development_dependency(%q<test-unit>.freeze, ["~> 3.0"])
    else
      s.add_dependency(%q<bundler>.freeze, ["~> 1.7"])
      s.add_dependency(%q<rake>.freeze, ["~> 12.0"])
      s.add_dependency(%q<test-unit>.freeze, ["~> 3.0"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 1.7"])
    s.add_dependency(%q<rake>.freeze, ["~> 12.0"])
    s.add_dependency(%q<test-unit>.freeze, ["~> 3.0"])
  end
end
