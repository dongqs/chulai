# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chulai/version'

Gem::Specification.new do |spec|
  spec.name          = "chulai"
  spec.version       = Chulai::VERSION
  spec.authors       = ["Dong Qingshan"]
  spec.email         = ["dongqs@gmail.com"]
  spec.summary       = %q{Rails PaaS}
  spec.description   = %q{One click Rails deployment}
  spec.homepage      = "https://github.com/dongqs/chulai"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 0.19"
  spec.add_dependency "rest-client", "~> 1.7"
  spec.add_dependency "sshkey", "~> 1.6"
  spec.add_dependency "net-ssh", "~> 2.9"
  spec.add_dependency "git", "~> 1.2"
  spec.add_dependency "gemnasium-parser", "~> 0.1"
  spec.add_dependency "launchy", "~> 2.4"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.3"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 1.18"
  spec.add_development_dependency "guard-rspec", "~> 4.3"
  spec.add_development_dependency "guard-cucumber", "~> 1.4"
end
