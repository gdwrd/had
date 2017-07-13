# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'had/version'

Gem::Specification.new do |spec|
  spec.name          = 'had'
  spec.version       = Had::VERSION
  spec.authors       = ['nsheremet']
  spec.email         = ['nazariisheremet@gmail.com']
  spec.description   = %q{Had is Hanami Api Documentation gem. This gem generates API documentation for integration tests written with RSpec for Hanami}
  spec.summary       = %q{Generates API documentation for integration tests written with RSpec for Hanami}
  spec.homepage      = 'https://github.com/nsheremet/had'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'coderay'
  spec.add_dependency 'mime-types'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
