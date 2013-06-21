module Tire
  module Model
    module AsyncCallbacks

      extend ActiveSupport::Concern

      ID_CONVERSION = {
          'Moped::BSON::ObjectId' => :to_s
      }

      included do
        # Bind after save or create callback
        if self.respond_to? :after_commit
          after_commit :__async_tire_save_index

        elsif self.respond_to? :after_save
          after_save :__async_tire_save_index
        end

        # Bind before destroy callback
        if self.respond_to? :before_destroy
          before_destroy :__async_tire_delete_index
        end
      end

      def __async_tire_save_index
        __async_tire_callback :update
      end

      def __async_tire_delete_index
        __async_tire_callback :delete
      end

      def __async_tire_callback(type)
        case TireAsyncIndex.engine
          when :sidekiq
            TireAsyncIndex::Workers::SidekiqUpdateIndex.perform_async type, self.class.name, __async_tire_object_id

          when :resque
            Resque.enqueue TireAsyncIndex::Workers::ResqueUpdateIndex, type, self.class.name, __async_tire_object_id

          else
            case type
              when :update
                tire.update_index
              when :delete
                tire.index.remove self
            end
        end
      end

      def __async_tire_object_id
        if (method = ID_CONVERSION[self.id.class.name])
          self.id.send(method)
        else
          self.id
        end
      end

    end
  end
end
