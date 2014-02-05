# TireAsyncIndex

[![Build Status](https://secure.travis-ci.org/EvilFaeton/tire_async_index.png)](http://travis-ci.org/EvilFaeton/tire_async_index) [![endorse](https://api.coderwall.com/evilfaeton/endorsecount.png)](https://coderwall.com/evilfaeton)

It's extension for [Tire](https://github.com/karmi/tire/) (client for the Elasticsearch search engine), which allow to update index of ActiveRecord/ActiveModel model using background job (based on [Sidekiq](https://github.com/mperham/sidekiq) or [Resque](https://github.com/resque/resque)).

Requirements: Ruby 1.9, 2.0, Rails => 3.0

## Installation

Add this line to your application's Gemfile:

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

Also check that you include `tire` queue to `sidekiq.yml` or to `-q` param then you start sidekiq.
That's all.

## Custom identificator or finder

If you need more complex solution to define identificators and/or finder. You could simply add methods to override default:

    class User < ActiveRecord::Base
        include Tire::Model::Search
        include Tire::Model::AsyncCallbacks

        def self.tire_async_finder(id)
          User.where(...).first
        end

        def async_tire_object_id
          "#{id}-#{name}"
        end
    end

## TODO

* Add support for custom filter / custom finders
* Test for workers

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
