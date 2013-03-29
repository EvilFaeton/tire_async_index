require 'tire_assync_index/workers/sidekiq_update_index_worker' if TireAsyncIndex.configuration.engine == :sidekiq
require 'tire_assync_index/workers/resque_update_index_job'     if TireAsyncIndex.configuration.engine == :resque

module Tire
  module Model
    module AsyncCallbacks
      def self.included(base)

        if base.respond_to?(:after_save) && base.respond_to?(:after_destroy)
          base.send :after_save,    lambda { 
            case TireAsyncIndex.configuration.engine
            when :sidekiq
              SidekiqUpdateIndexWorker.perform_async(base.name, id)
            when :resque
              Resque.enqueue(ResqueUpdateIndexJob, base.name, id)
            else
              tire.update_index
            end
            self 
          }
          base.send :after_destroy, lambda { tire.update_index }, :order => :first
        end

        if base.respond_to?(:before_destroy) && !base.instance_methods.map(&:to_sym).include?(:destroyed?)
          base.class_eval do
            before_destroy  { @destroyed = true }
            def destroyed?; !!@destroyed; end
          end
        end

      end

    end

  end
end