# Ruby
require 'benchmark'


# Gems
require 'sinatra'
require 'json'
require 'awesome_print'
require 'newrelic_rpm'
require 'oauth'
require 'httparty'
require 'redis'
require 'mongoid'
require 'rufus-scheduler'


# Helper
require './app/helpers'


# Modules
require_all :modules
require_all :stats
require_all :stat_databases

# Models
require_all :models


# App
require './app/api'


$stdout.sync = true

set :raise_errors, true
set :show_exceptions, false

Mongoid.load!( 'config/mongoid.yml', :test)
Mongo::Logger.logger.level = Logger::ERROR

#scheduler = Rufus::Scheduler.new

#scheduler.in '1s' do
	#DataFactory.fetch_update_schedule
#	puts "scheduler"
#	DataFactory.update_previews_recaps
#end
