# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'git_mirror'
  spec.version       = '0.2'
  spec.authors       = 'Mick Staugaard'
  spec.email         = 'mick@zendesk.com'
  spec.description   = 'utility for mirroring github repositories'
  spec.summary       = 'utility for mirroring github repositories'
  spec.homepage      = ''

  spec.files         = Dir.glob('{lib,test,bin}/**/*') + ['README.md', 'bin/git-mirror']
  spec.test_files    = Dir.glob('test/**/*')
  spec.executables   = ['git-mirror']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_dependency 'thor'
end
