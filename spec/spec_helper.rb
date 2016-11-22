require 'rack'
require 'rspec'
require 'rack/test'
require 'webmock/rspec'


ENV[ 'RACK_ENV' ] = 'test'
ENV[ 'OAUTH2_ACCESS_TOKEN' ] = 'OAUTH2_ACCESS_TOKEN'

 # App
require './app/init'


# Helpers
require './spec/shared/helpers'


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
    yelp_url = 'http://api.yelp.com/v2/search?category_filter=sushi&limit=5&location=los%20angeles'

    WebMock.stub_request(:get, yelp_url )
      .to_return( status:200, body:yelp_response, headers:{} )

    Redis.new.flushdb
    Mongoid.purge!
  end
end

def app
  Sinatra::Application
end
