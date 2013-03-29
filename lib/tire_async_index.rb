require "tire_async_index/configuration"
require "tire_async_index/exceptions"
require "tire_async_index/version"
require "tire/model/assync_callbacks"

module TireAsyncIndex
  attr_accessor :configuration

  def configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end

TireAsyncIndex.configure {}
