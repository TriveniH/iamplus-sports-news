require 'base64'
require 'cgi'
require 'openssl'
require 'digest'

class NBANews

	DOMAIN = "http://api.stats.com/"
	ROUTE = "v1/editorial/basketball/nba/"

	def initialize action
		@action = action
	end

	def get_recap_of_game(gameId = "1674648")

		if(DBHelperRecap._check_if_exists(gameId))
			return DBHelperRecap._retrieve_recap(gameId)
		end
		event_url = "stories/recaps/events/"+gameId +"/?"
		url = ROUTE + event_url + Utils.get_api_key_signature_string(ENV['NBA_API_KEY'], ENV['NBA_SECRET'], gameId)
		puts "URL::"+ url
		response = make_api_request_generic url
		save_game(response.to_json, true)
		response

	end

	def get_preview_of_game(gameId = "1674648")
		if(DBHelperPreview._check_if_exists(gameId))
			return DBHelperPreview._retrieve_preview(gameId)
		end
		event_url = "stories/previews/events/"+gameId +"/?"
		url = ROUTE + event_url + Utils.get_api_key_signature_string(ENV['NBA_API_KEY'], ENV['NBA_SECRET'], gameId)
		puts "URL::"+ url
		response = make_api_request_generic url
		save_game(response.to_json, false)
		response
	end

	def get_game_bullets(gameId = "1674648")
	end

	def get_headlines_for_sport
		event_url = "stories/headlines/?"
		url = ROUTE + event_url + Utils.get_api_key_signature_string(ENV['NBA_API_KEY'], ENV['NBA_SECRET'], nil)
		puts "URL for heading::"+ url
		response = make_api_request_generic url
		response
	end

	def save_game(responseJson, isRecap)
		puts responseJson.to_s
		response = JSON.parse(responseJson)
		eventId = response["eventId"]
		content = response["content"]
		if eventId == nil || content == nil
			return
		end
		timeTaken = response["time_taken"]
		date = response["date"]
		dateType = response["date_type"]
		imageUrl = response["image_url"]
		headline = response["headline"]
		puts "headline:: "+ headline.to_s
		puts "response[:content]::"+ response["content"]["paragraphs"].to_s
		paragraphs = response["content"]["paragraphs"]
		if isRecap
			DBHelperRecap._save_recap(eventId, date,
				dateType, imageUrl, headline, paragraphs, "NBA")
		else
			DBHelperPreview._save_preview(eventId, date,
				dateType, imageUrl, headline, paragraphs, "NBA")
		end
	end

	def get_recent_stories_for_team
		get_headlines_for_sport
	end

	def make_api_request_generic(url)
		JsonUtils.make_api_request_generic(url, @action, ENV['NBA_API_KEY'], ENV['NBA_SECRET'] , DOMAIN, ROUTE)
	end
end