class ResqueUpdateIndexJob

  def self.queue
    TireAsyncIndex.queue
  end

  def self.perform class_name, id
    class_name.constantize.find_by_id(id).try(:update_index)
  end

end