# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'basecamp/version'

Gem::Specification.new do |spec|
  spec.name          = 'basecamp'
  spec.version       = Basecamp::VERSION
  spec.authors       = ['Darin Haener']
  spec.email         = ['dphaener@gmail.com']
  spec.summary       = 'Gem for integrating a Rails app with the NEW Basecamp API using Oauth'
  spec.description   = 'This gem enables easy interaction with the NEW Basecamp API in Rails using Oauth'
  spec.homepage      = 'https://github.com/dphaener/basecamp'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 1.8.7'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'simplecov', '~> 0.7.1'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'minitest-reporters'
  spec.add_development_dependency 'mocha'
  spec.add_development_dependency 'shoulda'
  spec.add_development_dependency 'shoulda-matchers'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'debugger'

  spec.add_runtime_dependency 'virtus', '~> 1.0'
  spec.add_runtime_dependency 'oauth2', '~> 0.8'
end
