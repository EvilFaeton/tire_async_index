require 'test_helper'
require 'tire'
require 'tire_async_index'

class SomeModel
  attr_accessor :id
  include Tire::Model::AsyncCallbacks

end

describe TireAsyncIndex do
  context "configurable" do
    it "valid default config settings" do
      TireAsyncIndex.queue_name.should eql :normal
      TireAsyncIndex.engine.should eql :none
    end

    it "set queue name" do
      TireAsyncIndex.configure do |config|
        config.use_queue :high
      end

      TireAsyncIndex.queue_name.should eql :high
    end    

    it "should be able to set sidekiq as engine" do
      TireAsyncIndex.configure do |config|
        config.background_engine :sidekiq
      end

      TireAsyncIndex.engine.should eql :sidekiq
    end

    it "should be able to set resque as engine" do
      TireAsyncIndex.configure do |config|
        config.background_engine :resque
      end

      TireAsyncIndex.engine.should eql :resque
    end

    it "should not be able to set not supported engine" do
      expect {
        TireAsyncIndex.configure do |config|
          config.background_engine :some_engine
        end
      }.to raise_error(TireAsyncIndex::EngineNotFound)
    end
  end

  context "integration" do



  end
end