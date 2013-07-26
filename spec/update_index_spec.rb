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

class ArUser < ActiveRecord::Base
  include Tire::Model::AsyncCallbacks
end

class ArUserFinder < ActiveRecord::Base
  include Tire::Model::AsyncCallbacks

  def self.tire_async_finder(id)
    nil
  end
end

describe TireAsyncIndex::Workers::UpdateIndex do

  describe '#process' do
    let(:instance) { described_class.new }

    it 'resolves class constant' do
      expect {
        instance.process(:nothing, 'Level1::Level2::Model', 123)
      }.not_to raise_error
    end

    it 'trigger find on simple ar model' do
      ArUser.should_receive(:find).with(123).and_return(nil)
      instance.process(:update, 'ArUser', 123)
    end

    it 'trigger finder on ar mode with custom finder' do
      ArUserFinder.should_receive(:tire_async_finder).with(123).and_return(nil)
      instance.process(:update, 'ArUserFinder', 123)
    end
  end

end
