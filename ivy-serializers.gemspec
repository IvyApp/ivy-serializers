require File.expand_path('../lib/ivy/serializers/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name = 'ivy-serializers'
  spec.version = Ivy::Serializers::VERSION
  spec.authors = ['Dray Lacy']
  spec.email = ['dray@envylabs.com']
  spec.summary = 'JSON serialization for client-side apps.'
  spec.homepage = ''
  spec.license = 'MIT'

  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 2.2.1'
  spec.add_dependency 'hash_generator', '~> 1.1'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'json-schema-rspec', '~> 0.0.4'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.2.0'
  spec.add_development_dependency 'simplecov', '~> 0.12.0'
end
