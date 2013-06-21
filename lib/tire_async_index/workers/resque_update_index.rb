module TireAsyncIndex
  module Workers
    class ResqueUpdateIndex < UpdateIndex
      def self.queue; TireAsyncIndex.queue end

      def self.perform(*args)
        self.new.perform *args
      end
    end
  end
end
