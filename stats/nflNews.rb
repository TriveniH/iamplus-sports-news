require 'base64'
require 'cgi'
require 'openssl'
require 'digest'

class NFLNews
	DOMAIN = "http://api.stats.com/"
	ROUTE = "v1/editorial/football/nfl/"

	def initialize action
		@action = action
	end

	def get_recap_of_game(gameId = "1635823")

		if(DBHelperRecap._check_if_exists(gameId))
			return DBHelperRecap._retrieve_recap(gameId)
		end

		event_url = "stories/recaps/events/"+gameId +"/?"
		url = ROUTE + event_url + Utils.get_api_key_signature_string(ENV['NFL_API_KEY'], ENV['NFL_SECRET'], gameId)
		puts "URL::"+ url
		response = make_api_request_generic url
		save_game(response.to_json, true)
		response
	end

	def get_preview_of_game(gameId = "1635823")
		if(DBHelperPreview._check_if_exists(gameId))
			return DBHelperPreview._retrieve_preview(gameId)
		end
		event_url = "stories/previews/events/"+gameId +"/?"
		url = ROUTE + event_url + Utils.get_api_key_signature_string(ENV['NFL_API_KEY'], ENV['NFL_SECRET'], gameId)
		puts "URL::"+ url
		response = make_api_request_generic url
		save_game(response.to_json, false)
		response
	end

	def get_game_bullets(gameId = "1635823")
	end

	def get_headlines_for_sport
		event_url = "stories/headlines/?"
		url = ROUTE + event_url + Utils.get_api_key_signature_string(ENV['NFL_API_KEY'], ENV['NFL_SECRET'], nil)
		puts "URL for heading::"+ url
		response = make_api_request_generic url
		response
	end
=begin

	def make_api_request url
		response_back = nil
		api_request_time = Benchmark.realtime do
			request = APIRequest.new( :generic, DOMAIN )
			puts "url::"+ url.to_s
			response = request.for( :get, url, '')

			request_status = Utils.check_response_status response
			if request_status != nil
				return request_status
			end

			response_back = JsonUtils.process_response(response.body, ENV['NFL_API_KEY'], ENV['NFL_SECRET'] , DOMAIN, ROUTE)
		end
		response_back
	end

	def make_api_request_for_headlines url
		response_back = nil
		api_request_time = Benchmark.realtime do
			request = APIRequest.new( :generic, DOMAIN )
			puts "url::"+ url.to_s
			response = request.for( :get, url, '')

			request_status = Utils.check_response_status response
			if request_status != nil
				return request_status
			end

			response_back = JsonUtils.process_response_for_headlines(response.body, ENV['NFL_API_KEY'], ENV['NFL_SECRET'] , DOMAIN, ROUTE)
		end
		response_back
	end
=end

	def save_game(responseJson, isRecap)
		puts responseJson.to_s
		response = JSON.parse(responseJson)
		eventId = response["eventId"]
		content = response["content"]
		if eventId == nil || content == nil
			return
		end

		date = response["date"]
		dateType = response["date_type"]
		imageUrl = response["image_url"]
		headline = response["headline"]
		puts "headline:: "+ headline.to_s
		puts "response[:content]::"+ response["content"]["paragraphs"].to_s
		paragraphs = response["content"]["paragraphs"]
		if isRecap
			DBHelperRecap._save_recap(eventId, date,
				dateType, imageUrl, headline, paragraphs, "NFL")
		else
			DBHelperPreview._save_preview(eventId, date,
				dateType, imageUrl, headline, paragraphs, "NFL")
		end
	end

	def get_recent_stories_for_team team_id
		event_url = "stories/recent/teams/"+ team_id +"/?"
		url = ROUTE + event_url + Utils.get_api_key_signature_string(ENV['NFL_API_KEY'], ENV['NFL_SECRET'], nil)
		puts "URL for heading::"+ url
		response = make_api_request_generic url
		response
	end

	def make_api_request_generic(url)
		JsonUtils.make_api_request_generic(url, @action, ENV['NFL_API_KEY'], ENV['NFL_SECRET'] , DOMAIN, ROUTE)
	end
end