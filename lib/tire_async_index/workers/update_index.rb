module TireAsyncIndex
  module Workers

    # Worker for updating ElasticSearch index
    class UpdateIndex

      # Update or delete ElasticSearch index based on the action_type parameter.
      #
      # Parameters:
      #   action_type - Determine index direction. (allowed value - Update or Delete)
      #   class_name - Model class name
      #   id - Document id
      #
      def self.run(action_type, class_name, id)
        TireAsyncIndex::Workers::Sidekiq.new.process(action_type, class_name, id)
      end

      def process(action_type, class_name, id)
        klass = find_class_const(class_name)

        case action_type.to_sym
          when :update
            object = klass.find(id)

            if object.present? && object.respond_to?(:tire)
              object.tire.update_index
            end
          when :delete

            klass.new.tap do |inst|
              inst.tire.index.remove(inst.tire.document_type, { _id: id })
            end
        end
      end

      def find_class_const(class_name)
        if defined?(RUBY_VERSION) && RUBY_VERSION.match(/^2\./)
          Kernel.const_get(class_name)
        else
          class_name.split('::').reduce(Object) do |mod, const_name|
            mod.const_get(const_name)
          end
        end
      end
    end
  end
end
