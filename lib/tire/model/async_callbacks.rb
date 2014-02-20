module Tire
  module Model
    module AsyncCallbacks

      ID_CONVERSION = {
          'Moped::BSON::ObjectId' => :to_s
      }

      def self.included(base)
        # Bind after save or create callback
        if base.respond_to? :after_commit
          base.send :after_commit, :async_tire_save_index, :if => :persisted?

        elsif base.respond_to? :after_save
          base.send :after_save, :async_tire_save_index
        end

        # Bind before destroy callback
        if base.respond_to? :before_destroy
          base.send :before_destroy, :async_tire_delete_index
        end
      end

      private

      def async_tire_save_index
        async_tire_callback :update
      end

      def async_tire_delete_index
        async_tire_callback :delete
      end

      def async_tire_callback(type)
        if TireAsyncIndex.engine == :none
          case type
          when :update
            tire.update_index
          when :delete
            tire.index.remove self
          end
        else
          TireAsyncIndex.worker.run(type, self.class.name, get_async_tire_object_id)
        end
      end

      def get_async_tire_object_id
        if self.respond_to?(:async_tire_object_id)
          self.send(:async_tire_object_id)
        else
          if (method = ID_CONVERSION[self.id.class.name])
            self.id.send(method)
          else
            self.id
          end
        end
      end

    end
  end
end
