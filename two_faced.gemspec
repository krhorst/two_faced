# -*- encoding: utf-8 -*-
require File.expand_path('../lib/two_faced/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Kevin Horst"]
  gem.email         = ["krhorst@gmail.com"]
  gem.description   = "Monkey-patch your data"
  gem.summary       = "Add context-specific overrides to model attributes without new columns"
  gem.homepage      = "http://github.com/krhorst/two_faced"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "two_faced"
  gem.require_paths = ["lib"]
  gem.version       = TwoFaced::VERSION
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "jasmine"
end
