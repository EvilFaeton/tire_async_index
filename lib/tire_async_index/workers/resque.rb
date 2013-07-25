module TireAsyncIndex
  module Workers
    class Resque < UpdateIndex
      def self.queue; TireAsyncIndex.queue end

      def run(action_type, class_name, id)
        ::Resque.enqueue TireAsyncIndex::Workers::Resque, action_type, class_name, id
      end

      def self.perform(action_type, class_name, id)
        process(action_type, class_name, id)
      end
    end
  end
end
