require 'base64'
require 'cgi'
require 'openssl'
require 'digest'

class EPLNews
	DOMAIN = "http://api.stats.com/"
	ROUTE = "v1/editorial/soccer/epl/"

	def initialize
	end

	def get_recap_of_game1(gameId = "1643062")
		event_url = "stories/recaps/events/"+gameId +"/?"
		url = ROUTE + event_url + Utils.get_api_key_signature_string(ENV['EPL_API_KEY'], ENV['EPL_SECRET'])
		puts "URL::"+ url
		response = make_api_request url
		save_game response.to_json
		response
	end

	def get_preview_of_game(gameId = "1643062")
		if(DBHelper._check_if_exists(gameId))
			return DBHelper._retrieve_news(gameId)
		end
		event_url = "stories/previews/events/"+gameId +"/?"
		url = ROUTE + event_url + Utils.get_api_key_signature_string(ENV['EPL_API_KEY'], ENV['EPL_SECRET'])
		puts "URL::"+ url
		response = make_api_request url
		save_game response.to_json
		response
	end

	def get_game_bullets(gameId = "1643062")
	end

	def get_headlines_for_sport
		event_url = "stories/headlines/?"
		url = ROUTE + event_url + Utils.get_api_key_signature_string(ENV['EPL_API_KEY'], ENV['EPL_SECRET'])
		puts "URL for heading::"+ url
		response = make_api_request_for_headlines url
		response
	end

	def make_api_request url
		response_back = nil
		api_request_time = Benchmark.realtime do
			request = APIRequest.new( :generic, DOMAIN )
			puts "url::"+ url.to_s
			response = request.for( :get, url, '')
			response_back = JsonUtils.process_response(response.body, ENV['EPL_API_KEY'], ENV['EPL_SECRET'] , DOMAIN, ROUTE)
		end
		response_back
	end

	def make_api_request_for_headlines url
		response_back = nil
		api_request_time = Benchmark.realtime do
			request = APIRequest.new( :generic, DOMAIN )
			puts "url::"+ url.to_s
			response = request.for( :get, url, '')
			response_back = JsonUtils.process_response_for_headlines(response.body, ENV['EPL_API_KEY'], ENV['EPL_SECRET'] , DOMAIN, ROUTE)
		end
		response_back
	end

	def save_game responseJson
		puts responseJson.to_s
		response = JSON.parse(responseJson)
		eventId = response["eventId"]
		timeTaken = response["time_taken"]
		date = response["date"]
		dateType = response["date_type"]
		imageUrl = response["image_url"]
		headline = response["headline"]
		puts "headline:: "+ headline.to_s
		puts "response[:content]::"+ response["content"]["paragraphs"].to_s
		paragraphs = response["content"]["paragraphs"]
		DBHelper._save_news(eventId, timeTaken, date,
			dateType, imageUrl, headline, paragraphs)
	end

	def get_recent_stories_for_team
		{status: "work In Progress for recent stories for team"}
	end

end