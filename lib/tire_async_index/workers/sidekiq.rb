module TireAsyncIndex
  module Workers
    class Sidekiq < UpdateIndex
      include ::Sidekiq::Worker
      sidekiq_options queue: TireAsyncIndex.queue

      def self.run(action_type, class_name, id)
        TireAsyncIndex::Workers::Sidekiq
          .perform_async(action_type, class_name, id)
      end

      def perform(action_type, class_name, id)
        process(action_type, class_name, id)
      rescue Exception => e
        if TireAsyncIndex.error_handler
          TireAsyncIndex.error_handler.handle(self, action_type, class_name, id, e)
        else
          raise e
        end
      end

    end
  end
end
