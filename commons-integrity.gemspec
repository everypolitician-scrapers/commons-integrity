# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = 'commons-integrity'
  spec.version       = '0.1'
  spec.authors       = ['Tony Bowden', 'Alex Dutton']
  spec.email         = ['parliaments@mysociety.org']

  spec.summary       = 'Check the integrity of Democratic Commons data'
  spec.homepage      = 'https://github.com/everypolitician/commons-integrity'
  spec.license       = 'MIT'

  spec.required_ruby_version = '~> 2.4.0'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = 'bin'
  spec.executables = ['check']
  spec.require_paths = ['lib']

  spec.add_dependency 'json'
  spec.add_dependency 'require_all'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'reek'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'webmock', '~> 2.0'
end
