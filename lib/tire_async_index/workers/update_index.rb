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
      def perform(action_type, class_name, id)
        clazz = class_name.constantize

        case action_type
          when :update
            object = clazz.find(id) rescue nil
            object.present? && object.respond_to?(:tire) && object.tire.update_index

          when :delete
            object.new.tap do |inst|
              tire.remove(inst.tire.document_type, { _id: id })
            end
        end

      end

    end
  end
end