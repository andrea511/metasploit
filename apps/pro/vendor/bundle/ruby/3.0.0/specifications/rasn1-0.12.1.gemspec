# -*- encoding: utf-8 -*-
# stub: rasn1 0.12.1 ruby lib

Gem::Specification.new do |s|
  s.name = "rasn1".freeze
  s.version = "0.12.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/sdaubert/rasn1/issues", "documentation_uri" => "https://www.rubydoc.info/gems/rasn1", "homepage_uri" => "https://github.com/sdaubert/rasn1", "source_code_uri" => "https://github.com/sdaubert/rasn1" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Sylvain Daubert".freeze]
  s.date = "2022-12-23"
  s.description = "RASN1 is a pure ruby ASN.1 library. It may encode and decode DER and BER\nencodings.\n".freeze
  s.email = ["sylvain.daubert@laposte.net".freeze]
  s.extra_rdoc_files = ["README.md".freeze, "LICENSE".freeze]
  s.files = ["LICENSE".freeze, "README.md".freeze]
  s.homepage = "https://github.com/sdaubert/rasn1".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--title".freeze, "RASN1 - A pure ruby ASN.1 library".freeze, "--main".freeze, "README.md".freeze, "--inline-source".freeze, "--quiet".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.5.0".freeze)
  s.rubygems_version = "3.2.22".freeze
  s.summary = "Ruby ASN.1 library".freeze

  s.installed_by_version = "3.2.22" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<strptime>.freeze, ["~> 0.2.5"])
  else
    s.add_dependency(%q<strptime>.freeze, ["~> 0.2.5"])
  end
end
