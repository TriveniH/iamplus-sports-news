module DataFactory

	def DataFactory.fetch_update_schedule

		domain = "http://api.stats.com/"

		route = "v1/stats/soccer/epl/"
		url = route + "scores/?season=2016&" + Utils.get_api_key_signature_string(ENV['EPL_API_KEY'], ENV['EPL_SECRET'], nil)
		make_request(url, "EPL")

		route = "v1/stats/basketball/nba/"
		url = route + "scores/?season=2016&" + Utils.get_api_key_signature_string(ENV['NBA_API_KEY'], ENV['NBA_SECRET'], nil)
		make_request(url, "NBA")

		route = "v1/stats/baseball/mlb/"
		url = route + "scores/?season=2016&" + Utils.get_api_key_signature_string(ENV['MLB_API_KEY'], ENV['MLB_SECRET'], nil)
		make_request(url, "MLB")

		route = "v1/stats/football/nfl/"
		url = route + "scores/?season=2016&" + Utils.get_api_key_signature_string(ENV['NFL_API_KEY'], ENV['NFL_SECRET'], nil)
		make_request(url, "NFL")

	end

	def DataFactory.make_request(url, league)
		puts "url:"+ url
		puts "league:"+ league
		domain = "http://api.stats.com/"

		api_request_time = Benchmark.realtime do
			request = APIRequest.new( :generic, domain )
			response = request.for( :get, url, '')
			#puts "response from scheduler:: "+ response.body.to_s
			parse_response(response.body, league)
		end	
	end

	def DataFactory.parse_response(response, league)
		parsedJson = JSON.parse(response)
		if parsedJson["status"] != "OK"
			return nil
		end

		apiResults = parsedJson["apiResults"]
		eventIdList = []
		startDateList = []
		team1IdList = []
		team2IdList = []
		apiResults.each do | result|
			eventTypes = result["league"]["season"]["eventType"]
			eventTypes.each do |eventType|
				events = eventType["events"]
				puts "events.length::"+ events.length.to_s
				events.each do |event|
					eventId = event["eventId"]
					startDates = event["startDate"]
					startDate = startDates[0]
					unixTime = startDate["full"]
					teams = event["teams"]
					team1 = teams[0]
					team2 = teams[1]
					team1_id = team1["teamId"]
					team2_id = team2["teamId"]
					eventIdList << eventId
					startDateList << unixTime
					team1IdList << team1_id
					team2IdList << team2_id
				end
			end
		end

		case league
		when "EPL" then
			DBHelperEPLSeason._save_season(eventIdList, startDateList, team1IdList, team2IdList)
		when "NFL" then
			DBHelperNFLSeason._save_season(eventIdList, startDateList, team1IdList, team2IdList)
		when "NBA" then
			DBHelperNBASeason._save_season(eventIdList, startDateList, team1IdList, team2IdList)
		when "MLB" then
			DBHelperMLBSeason._save_season(eventIdList, startDateList, team1IdList, team2IdList)
		end
	end

	def DataFactory.update_previews_recaps

		#pull for EPL
		eplNews = EPLNews.new(Constants::ACTION_PREVIEW)
		eplNews.get_preview_for_ids(DBHelperEPLSeason._get_event_ids_for_preview)
		eplNews = EPLNews.new(Constants::ACTION_RECAP)
		eplNews.get_recap_for_ids(DBHelperEPLSeason._get_event_ids_for_recap)

		#pull for NBA
		nbaNews = NBANews.new(Constants::ACTION_PREVIEW)
		nbaNews.get_preview_for_ids(DBHelperNBASeason._get_event_ids_for_preview)
		nbaNews = NBANews.new(Constants::ACTION_RECAP)
		nbaNews.get_recap_for_ids(DBHelperNBASeason._get_event_ids_for_recap)

		#pull for MLB
		mlbNews = MLBNews.new(Constants::ACTION_PREVIEW)
		mlbNews.get_preview_for_ids(DBHelperMLBSeason._get_event_ids_for_preview)
		mlbNews = MLBNews.new(Constants::ACTION_RECAP)
		mlbNews.get_recap_for_ids(DBHelperMLBSeason._get_event_ids_for_recap)

		#pull for NFL
		nflNews = NFLNews.new(Constants::ACTION_PREVIEW)
		nflNews.get_preview_for_ids(DBHelperNFLSeason._get_event_ids_for_preview)
		nflNews = NFLNews.new(Constants::ACTION_RECAP)
		nflNews.get_recap_for_ids(DBHelperNFLSeason._get_event_ids_for_recap)

	end

end