# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tire_async_index/version'

Gem::Specification.new do |spec|
  spec.name          = "tire_async_index"
  spec.version       = TireAsyncIndex::VERSION
  spec.authors       = ["Sergey Efremov"]
  spec.email         = ["efremov.sergey@gmail.com"]
  spec.description   = "Update tire (elasticsearch) index async with Sidekiq or Resque"
  spec.summary       = "Update tire (elasticsearch) index async with Sidekiq or Resque"
  spec.homepage      = "http://github.com/EvilFaeton/tire_async_index"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "tire"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "activerecord"
  spec.add_development_dependency "sidekiq"
  spec.add_development_dependency "resque"
  spec.add_development_dependency "rspec"
end
