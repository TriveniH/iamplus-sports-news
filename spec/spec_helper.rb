require 'rack'
require 'rspec'
require 'rack/test'
require 'webmock/rspec'
require 'simplecov'


ENV[ 'RACK_ENV' ] = 'test'
ENV[ 'OAUTH2_ACCESS_TOKEN' ] = 'OAUTH2_ACCESS_TOKEN'

SimpleCov.start

 # App
require './app/init'


# Helpers
require './spec/shared/helpers'
require_all :spec

RSpec.configure do |config|
  config.filter_run focus:true
  config.run_all_when_everything_filtered = true
  config.color = true

  config.include Rack::Test::Methods

  config.backtrace_exclusion_patterns = [
    /\/lib\d*\/ruby\//,
    /bin\//,
    /gems/,
    /spec\/spec_helper\.rb/,
    /lib\/rspec\/(core|expectations|matchers|mocks)/
  ]

  config.before( :each ) do

    Redis.new.flushdb
#    Mongoid.purge!
  end
end

def app
  Sinatra::Application
end
