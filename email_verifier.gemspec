# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'email_verifier/version'

Gem::Specification.new do |gem|
  gem.name          = "email_verifier"
  gem.version       = EmailVerifier::VERSION
  gem.authors       = ["Kamil Ciemniewski"]
  gem.email         = ["kamil@endpoint.com"]
  gem.description   = %q{Helper utility checking if given email address exists or not}
  gem.summary       = %q{Helper utility checking if given email address exists or not}
  gem.homepage      = "http://endpoint.com"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_runtime_dependency(%q<dnsruby>, [">= 1.5"])
  gem.license = 'MIT'
end
