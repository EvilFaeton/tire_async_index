require "rubygems"
require "bundler/setup"
require "tire"
require 'rails'
require 'active_record'
require 'nulldb_rspec'
require 'nulldb/rails'
#include NullDB::RSpec::NullifiedDatabase
NullDB.configure {|ndb| ndb.project_root = 'spec'}
ActiveRecord::Base.establish_connection adapter: :nulldb,
                                        schema:  'test_schema.rb'

RSpec.configure do |config|
  config.mock_with :rspec
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end