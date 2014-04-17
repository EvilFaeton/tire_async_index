require "tire_async_index/configuration"
require "tire_async_index/exceptions"
require "tire_async_index/version"

module TireAsyncIndex
  extend self
  attr_accessor :configuration

  def configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  def queue
    self.configuration.queue
  end

  def engine
    self.configuration.engine
  end

  def error_handler
    self.configuration.error_handler
  end

  def worker
    case configuration.engine
    when :sidekiq
      TireAsyncIndex::Workers::Sidekiq
    when :resque
      TireAsyncIndex::Workers::Resque
    else
      TireAsyncIndex::Workers::UpdateIndex
    end
  end

  module Workers
    autoload :UpdateIndex, 'tire_async_index/workers/update_index'
    autoload :Sidekiq,     'tire_async_index/workers/sidekiq'
    autoload :Resque,      'tire_async_index/workers/resque'
  end

end

require 'tire/model/async_callbacks'

TireAsyncIndex.configure {}
