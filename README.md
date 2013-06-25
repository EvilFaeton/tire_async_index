# TireAsyncIndex

[![Build Status](https://secure.travis-ci.org/EvilFaeton/tire_async_index.png)](http://travis-ci.org/EvilFaeton/tire_async_index) [![endorse](https://api.coderwall.com/evilfaeton/endorsecount.png)](https://coderwall.com/evilfaeton)

It's extension for [Tire](https://github.com/karmi/tire/) (client for the Elasticsearch search engine), which allow to update index of ActiveRecord/ActiveModel model using background job (based on [Sidekiq](https://github.com/mperham/sidekiq) or [Resque](https://github.com/resque/resque)).

Requirements: Ruby 1.9, 2.0, Rails => 3.0

## Installation

Add this line to your application's Gemfile after `tire` and `sidekiq` or `resque` gems:

    gem 'tire'
    gem 'sidekiq' #'resque'
    gem 'tire_async_index'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tire_async_index

## Configuration

You could configure TireAsyncIndex in initializer:
    
    TireAsyncIndex.configure do |config|
        config.background_engine :sidekiq # or :resque
        config.use_queue         :high    # name of your queue
    end

## Usage

Just add AsyncCallbacks to your model:
    
    class User < ActiveRecord::Base
        include Tire::Model::Search
        include Tire::Model::AsyncCallbacks
        
        ...
    end
    
That's all.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
