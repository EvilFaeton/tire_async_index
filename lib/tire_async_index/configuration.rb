module TireAsyncIndex
  class Configuration
    AVALAIBLE_ENGINE = [:sidekiq, :resque, :none]

    attr_accessor :queue
    attr_accessor :engine

    def backend_engine type
      if AVALAIBLE_ENGINE.include?(type.to_sym)
        @engine = type.to_sym
      else
        raise EngineNotFound, "Background Engine '#{type}' not found"
      end
    end

    def use_queue name
      @queue = name.to_sym
    end

    def initialize
      @queue  = :normal
      @engine = :none
    end

  end
end