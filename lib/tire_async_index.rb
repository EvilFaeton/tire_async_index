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
    SidekiqUpdateIndexWorker.sidekiq_options_hash["queue"] = TireAsyncIndex.queue if defined?(Sidekiq)
  end

end

require 'tire_async_index/workers/sidekiq_update_index_worker' if defined?(Sidekiq)
require 'tire_async_index/workers/resque_update_index_job'     if defined?(Resque)
require 'tire/model/async_callbacks'
TireAsyncIndex.configure {}
