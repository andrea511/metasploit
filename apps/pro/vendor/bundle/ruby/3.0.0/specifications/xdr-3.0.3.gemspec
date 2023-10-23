# -*- encoding: utf-8 -*-
# stub: xdr 3.0.3 ruby lib

Gem::Specification.new do |s|
  s.name = "xdr".freeze
  s.version = "3.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/astroband/ruby-xdr/issues", "changelog_uri" => "https://github.com/astroband/ruby-xdr/blob/v3.0.3/CHANGELOG.md", "documentation_uri" => "https://rubydoc.info/gems/xdr/3.0.3/", "github_repo" => "https://github.com/astroband/ruby-xdr", "source_code_uri" => "https://github.com/astroband/ruby-xdr/tree/v3.0.3" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Scott Fleckenstein".freeze]
  s.bindir = "exe".freeze
  s.date = "2022-02-18"
  s.email = ["scott@stellar.org".freeze]
  s.extra_rdoc_files = ["README.md".freeze, "LICENSE.txt".freeze, "CHANGELOG.md".freeze]
  s.files = ["CHANGELOG.md".freeze, "LICENSE.txt".freeze, "README.md".freeze]
  s.homepage = "https://github.com/astroband/ruby-xdr".freeze
  s.licenses = ["Apache-2.0".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.4.0".freeze)
  s.rubygems_version = "3.2.22".freeze
  s.summary = "XDR Helper Library".freeze

  s.installed_by_version = "3.2.22" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<activesupport>.freeze, [">= 4.2", "< 8.0"])
    s.add_runtime_dependency(%q<activemodel>.freeze, [">= 4.2", "< 8.0"])
  else
    s.add_dependency(%q<activesupport>.freeze, [">= 4.2", "< 8.0"])
    s.add_dependency(%q<activemodel>.freeze, [">= 4.2", "< 8.0"])
  end
end
