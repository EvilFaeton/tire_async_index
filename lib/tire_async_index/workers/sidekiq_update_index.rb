module TireAsyncIndex
  module Workers
    class SidekiqUpdateIndex < UpdateIndex
      include Sidekiq::Worker
      sidekiq_options queue: :normal
    end
  end
end