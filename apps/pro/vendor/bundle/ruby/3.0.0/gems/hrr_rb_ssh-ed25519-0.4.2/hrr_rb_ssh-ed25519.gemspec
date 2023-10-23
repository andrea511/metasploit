# coding: utf-8
# vim: et ts=2 sw=2

require_relative 'lib/hrr_rb_ssh/ed25519/version'

Gem::Specification.new do |spec|
  spec.name          = "hrr_rb_ssh-ed25519"
  spec.version       = HrrRbSsh::Ed25519::VERSION
  spec.authors       = ["hirura"]
  spec.email         = ["hirura@gmail.com"]

  spec.summary       = %q{hrr_rb_ssh extension that supports ED25519 public key algorithm.}
  spec.description   = %q{hrr_rb_ssh extension that supports ED25519 public key algorithm.}
  spec.homepage      = "https://github.com/hirura/hrr_rb_ssh-ed25519"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  #spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]

  spec.required_ruby_version = Gem::Requirement.new(">= 2.0.0")

  spec.add_runtime_dependency "hrr_rb_ssh", ">= 0.4"
  spec.add_runtime_dependency "ed25519", "~> 1.2"

  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov", "~> 0.16"
end
