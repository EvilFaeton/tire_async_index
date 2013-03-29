class ResqueUpdateIndexJob

  @queue = TireAsyncIndex.configuration.queue

  def self.perform class_name, id
    class_name.constantize.find_by_id(id).try(:update_index)
  end

end