require "tire_async_index/configuration"
require "tire_async_index/exceptions"
require "tire_async_index/version"

module TireAsyncIndex
  extend self
  attr_accessor :configuration

  def configure
    self.configuration ||= Configuration.new
    yield(configuration)
    reconfig_workers
  end

  def queue
    self.configuration.queue
  end

  def engine
    self.configuration.engine
  end

  def reconfig_workers
    if defined?(Sidekiq)
      Workers::SidekiqUpdateIndex.sidekiq_options_hash["queue"] = TireAsyncIndex.queue
    end
  end

  module Workers
    autoload :UpdateIndex, 'tire_async_index/workers/update_index'
  end

end

require 'tire_async_index/workers/sidekiq_update_index' if defined?(Sidekiq)
require 'tire_async_index/workers/resque_update_index' if defined?(Resque)
require 'tire/model/async_callbacks'

TireAsyncIndex.configure {}
