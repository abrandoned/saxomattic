# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'saxomattic/version'

Gem::Specification.new do |gem|
  gem.name          = "saxomattic"
  gem.version       = Saxomattic::VERSION
  gem.authors       = ["Brandon Dewitt"]
  gem.email         = ["brandonsdewitt+saxomattic@gmail.com"]
  gem.description   = %q{ A gem to combine all the wonderful that is sax-machine with the magic that is active_attr }
  gem.summary       = %q{ By including a module "Saxomattic" you can declare xml structured documents with active_attr goodies }
  gem.homepage      = "https://github.com/abrandoned/saxomattic.git"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "active_attr"
  gem.add_dependency "activesupport"
  gem.add_dependency "sax-machine"

  gem.add_development_dependency "pry"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "simplecov"
end
