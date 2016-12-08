require 'base64'
require 'cgi'
require 'openssl'
require 'digest'

class EPLNews
	DOMAIN = "http://api.stats.com/"
	ROUTE = "v1/editorial/soccer/epl/"

	def initialize action
		@action = action
	end

	def get_recap_of_game(gameId = "1643062")
		if(DBHelperRecap._check_if_exists(gameId))
			return DBHelperRecap._retrieve_recap(gameId)
		end
		event_url = "stories/recaps/events/"+gameId +"/?"
		url = ROUTE + event_url + Utils.get_api_key_signature_string(ENV['EPL_API_KEY'], ENV['EPL_SECRET'], gameId)
		puts "URL::"+ url
		response = make_api_request_generic url
		save_game(response.to_json, true)
		puts "response::"+ response.to_s
		response
	end

	def get_preview_of_game(gameId = "1643062")
		if(DBHelperPreview._check_if_exists(gameId))
			return DBHelperPreview._retrieve_preview(gameId)
		end
		event_url = "stories/previews/events/"+gameId +"/?"
		url = ROUTE + event_url + Utils.get_api_key_signature_string(ENV['EPL_API_KEY'], ENV['EPL_SECRET'], gameId)
		puts "URL::"+ url
		response = make_api_request_generic url
		save_game(response.to_json, false)
		puts "response::"+ response.to_s
		response
	end

	def get_game_bullets(gameId = "1643062")
	end

	def get_headlines_for_sport
		#if already in db, pull the data from there itself, otherwise query and add save in the db
		if DBHelperHeadLines._check_if_league_exists("EPL")
			return DBHelperHeadLines._retrieve_headlines("EPL")
		end
		event_url = "stories/headlines/?"
		url = ROUTE + event_url + Utils.get_api_key_signature_string(ENV['EPL_API_KEY'], ENV['EPL_SECRET'], nil)
		puts "URL for heading::"+ url
		response = make_api_request_generic url
		#puts "response::----------------------\n"+ response.to_s
		Utils.save_headlines(response, "EPL")
		response
	end

	def make_api_request_generic(url)
		JsonUtils.make_api_request_generic(url, @action, ENV['EPL_API_KEY'], ENV['EPL_SECRET'] , DOMAIN, ROUTE)
	end

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
		paragraphs = response["content"]["paragraphs"]
		if isRecap
			DBHelperRecap._save_recap(eventId, date,
				dateType, imageUrl, headline, paragraphs, "EPL")
		else
			DBHelperPreview._save_preview(eventId, date,
				dateType, imageUrl, headline, paragraphs, "EPL")
		end
	end

	def get_recent_stories_for_team team_id
		# if already exists, show from local db for the team and also for the league.
		if DBHelperHeadLines._check_if_league_team_exists("EPL", team_id)
			return DBHelperHeadLines._retrieve_headlines_for_team("EPL", team_id)
		end
		event_url = "stories/recent/teams/"+ team_id +"/?"
		url = ROUTE + event_url + Utils.get_api_key_signature_string(ENV['EPL_API_KEY'], ENV['EPL_SECRET'], nil)
		puts "URL for heading::"+ url
		response = make_api_request_generic url
		Utils.save_headlines(response, "EPL")
		response
	end

end