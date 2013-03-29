require "bundler/gem_tasks"
require "rake/testtask"

desc 'Default: run specs'
task :default => :spec  

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new do |t|
  t.pattern = "spec/**/*_spec.rb"
end