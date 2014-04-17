module TireAsyncIndex
  module Workers
    class Resque < UpdateIndex

      def self.queue; TireAsyncIndex.queue end

      def self.run(action_type, class_name, id)
        ::Resque.enqueue TireAsyncIndex::Workers::Resque, action_type, class_name, id
      end

      def self.perform(action_type, class_name, id)
        self.new.process(action_type, class_name, id)
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
