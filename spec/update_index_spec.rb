require 'test_helper'
require 'tire'
require 'sidekiq'
require 'resque'
require 'tire_async_index'

module Level1
  module Level2
    class Model
    end
  end
end

describe TireAsyncIndex::Workers::UpdateIndex do

  describe '#perform' do
    let(:instance) { described_class.new }

    it 'resolves class constant' do
      expect {
        instance.process(:nothing, 'Level1::Level2::Model', 123)
      }.not_to raise_error
    end
  end

end
