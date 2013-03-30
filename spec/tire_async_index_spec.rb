require 'test_helper'
require 'tire'
require 'sidekiq'
require 'resque'
require 'tire_async_index'

class User < ActiveRecord::Base
  include Tire::Model::AsyncCallbacks
end

describe TireAsyncIndex do
  context "configurable" do
    it "valid default config settings" do
      TireAsyncIndex.queue.should eql :normal
      TireAsyncIndex.engine.should eql :none
    end

    it "set queue name" do
      TireAsyncIndex.configure do |config|
        config.use_queue :high
      end

      TireAsyncIndex.queue.should eql :high
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

    it "should not start backroub on no engine" do
      TireAsyncIndex.configure do |config|
        config.background_engine :none
      end
      a = User.new
      a.stub(:tire) { a }
      a.should_receive(:update_index)
      a.save
    end

    it "should start sidekiq" do
      TireAsyncIndex.configure do |config|
        config.background_engine :sidekiq
      end

      SidekiqUpdateIndexWorker.should_receive(:perform_async).with("User", instance_of(Fixnum))

      a = User.new
      a.save
    end

    it "should start resque" do
      TireAsyncIndex.configure do |config|
        config.background_engine :resque
      end

      Resque.should_receive(:enqueue).with(ResqueUpdateIndexJob, "User", instance_of(Fixnum))

      a = User.new
      a.save
    end

  end
end