class SidekiqUpdateIndexWorker

  include Sidekiq::Worker
  sidekiq_options queue: TireAsyncIndex.configuration.queue

  def perform class_name, id
    class_name.constantize.find_by_id(id).try(:update_index)
  end

end