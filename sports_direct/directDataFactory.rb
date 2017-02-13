module DirectDataFactory

	DOMAIN_ATOM = "http://xml.sportsdirectinc.com/Atom?feed=/"
	DOMAIN_SPORT_DATA = "http://xml.sportsdirectinc.com/sport/v2/"

	ATOM_SPORT_NBA = "basketball/nba/"
	SPORT_DATA_NBA = "basketball/NBA/"
	ATOM_SPORT_MLB = "baseball/mlb/"
	SPORT_DATA_MLB = "baseball/MLB/"
	ATOM_SPORT_NFL = "football/nfl/"
	SPORT_DATA_NFL = "football/NFL/"
	ATOM_SPORT_EPL = "soccer/prem/"
	SPORT_DATA_EPL = "soccer/PREM/"
	ATOM_SPORT_NHL = "hockey/nhl/"
	SPORT_DATA_NHL = "hockey/NHL/"

	ROUTE_PREVIEW = "competition-previews/&apiKey="
	ROUTE_PREVIEW_SPORTS_DATA = "news/previews/"
	ROUTE_RECAP = "competition-recaps/&apiKey="
	ROUTE_RECAP_SPORTS_DATA = "news/recaps/"
	ROUTE_HEADLINE = "breaking-news/&apiKey="
	ROUTE_HEADLINE_SPORTS_DATA = "news/breaking/"
	API_KEY = ENV['SPORTS_DIRECT_API_KEY']
	NEWER_THAN_PARAM_KEY = "&newerThan="

	def DirectDataFactory.fetch_all_data
=begin
		fetch_preview
		sleep 5
		fetch_recap
		sleep 5 
=end
		fetch_headline
	end

	def DirectDataFactory.fetch_preview
		time = Time.now - 1.month
		puts time.strftime("%Y-%m-%dT%H:%M:%S")

		url = get_route_for_sport_atom("NBA", ROUTE_PREVIEW) + API_KEY + NEWER_THAN_PARAM_KEY + time.strftime("%Y-%m-%dT%H:%M:%S")
		puts "sports_direct url = "+url
		make_request(url, "NBA", "preview")
		
		url = get_route_for_sport_atom("NFL", ROUTE_PREVIEW) + API_KEY + NEWER_THAN_PARAM_KEY + time.strftime("%Y-%m-%dT%H:%M:%S")
		puts "sports_direct url = "+url
		make_request(url, "NFL", "preview")

		url = get_route_for_sport_atom("NHL", ROUTE_PREVIEW) + API_KEY + NEWER_THAN_PARAM_KEY + time.strftime("%Y-%m-%dT%H:%M:%S")
		puts "sports_direct url = "+url
		make_request(url, "NHL", "preview")

		url = get_route_for_sport_atom("MLB", ROUTE_PREVIEW) + API_KEY + NEWER_THAN_PARAM_KEY + time.strftime("%Y-%m-%dT%H:%M:%S")
		puts "sports_direct url = "+url
		make_request(url, "MLB", "preview")
=begin		
		url = get_route_for_sport_atom("EPL", ROUTE_PREVIEW) + API_KEY + NEWER_THAN_PARAM_KEY + time.strftime("%Y-%m-%dT%H:%M:%S")
		puts "sports_direct url = "+url
		make_request(url, "EPL", "preview")

=end		
	end

	def DirectDataFactory.fetch_recap
		time = Time.now - 1.month
		puts time.strftime("%Y-%m-%dT%H:%M:%S")

		url = get_route_for_sport_atom("NBA", ROUTE_RECAP) + API_KEY + NEWER_THAN_PARAM_KEY + time.strftime("%Y-%m-%dT%H:%M:%S")
		puts "sports_direct url = "+url
		make_request(url, "NBA", "recap")
		
		url = get_route_for_sport_atom("NFL", ROUTE_RECAP) + API_KEY + NEWER_THAN_PARAM_KEY + time.strftime("%Y-%m-%dT%H:%M:%S")
		puts "sports_direct url = "+url
		make_request(url, "NFL", "recap")

		url = get_route_for_sport_atom("NHL", ROUTE_RECAP) + API_KEY + NEWER_THAN_PARAM_KEY + time.strftime("%Y-%m-%dT%H:%M:%S")
		puts "sports_direct url = "+url
		make_request(url, "NHL", "recap")

		url = get_route_for_sport_atom("MLB", ROUTE_RECAP) + API_KEY + NEWER_THAN_PARAM_KEY + time.strftime("%Y-%m-%dT%H:%M:%S")
		puts "sports_direct url = "+url
		make_request(url, "MLB", "recap")
=begin		
		url = get_route_for_sport_atom("EPL", ROUTE_RECAP) + API_KEY + NEWER_THAN_PARAM_KEY + time.strftime("%Y-%m-%dT%H:%M:%S")
		puts "sports_direct url = "+url
		make_request(url, "EPL", "recap")
=end
	end

	def DirectDataFactory.fetch_headline
		DirectDBHelperHeadlines.clearAllHeadlines
		time = Time.now - 2.days
		puts time.strftime("%Y-%m-%dT%H:%M:%S")

		url = get_route_for_sport_atom("NBA", ROUTE_HEADLINE) + API_KEY + NEWER_THAN_PARAM_KEY + time.strftime("%Y-%m-%dT%H:%M:%S")
		puts "sports_direct url for breaking-news = "+url
		make_request(url, "NBA", "headlines")

		url = get_route_for_sport_atom("NFL", ROUTE_HEADLINE) + API_KEY + NEWER_THAN_PARAM_KEY + time.strftime("%Y-%m-%dT%H:%M:%S")
		puts "sports_direct url for breaking-news = "+url
		make_request(url, "NFL", "headlines")

		url = get_route_for_sport_atom("NHL", ROUTE_HEADLINE) + API_KEY + NEWER_THAN_PARAM_KEY + time.strftime("%Y-%m-%dT%H:%M:%S")
		puts "sports_direct url for breaking-news = "+url
		make_request(url, "NHL", "headlines")

		url = get_route_for_sport_atom("MLB", ROUTE_HEADLINE) + API_KEY + NEWER_THAN_PARAM_KEY + time.strftime("%Y-%m-%dT%H:%M:%S")
		puts "sports_direct url for breaking-news = "+url
		make_request(url, "MLB", "headlines")
=begin
		url = get_route_for_sport_atom("EPL", ROUTE_HEADLINE) + API_KEY + NEWER_THAN_PARAM_KEY + time.strftime("%Y-%m-%dT%H:%M:%S")
		puts "sports_direct url for breaking-news = "+url
		make_request(url, "EPL", "headlines")
=end
	end

	def DirectDataFactory.get_route_for_sport_atom(sport, route)
		case sport
		when "NBA"
			ATOM_SPORT_NBA + route
		when "MLB"
			ATOM_SPORT_MLB + route
		when "NFL"
			ATOM_SPORT_NFL + route
		when "EPL"
			ATOM_SPORT_EPL + route
		when "NHL"
			ATOM_SPORT_NHL + route
		end
	end

	def DirectDataFactory.get_route_for_sport_data(sport, route)
		case sport
		when "NBA"
			SPORT_DATA_NBA + route
		when "MLB"
			SPORT_DATA_MLB + route
		when "NFL"
			SPORT_DATA_NFL + route
		when "EPL"
			SPORT_DATA_EPL + route
		when "NHL"
			SPORT_DATA_NHL + route
				
		end
	end

	def DirectDataFactory.make_request(url, league, action)
		puts "url:"+ url
		puts "league:"+ league
		response_back = nil
		titles = nil

		api_request_time = Benchmark.realtime do
			request = APIRequest.new( :generic, DOMAIN_ATOM )
			response = request.for( :get, url, '')
			titles =  XMLparser.process_xml_response_for_articleIds response.body.to_s
			final_responce = DirectDataFactory.fetch_detailed_articles(titles, action, league)
		end	
	end

	def DirectDataFactory.fetch_detailed_articles(titles, action, sport)
		route = ROUTE_PREVIEW_SPORTS_DATA
		case action
		when "preview" then
			route = ROUTE_PREVIEW_SPORTS_DATA
		when "recap" then
			route = ROUTE_RECAP_SPORTS_DATA
		when "headlines" then
			route = ROUTE_HEADLINE_SPORTS_DATA
		end
		url = get_route_for_sport_data(sport, route)
		titels_response = titles.map do |title|
			response_back = nil
			url = get_route_for_sport_data(sport, route) + title + "?apiKey="+API_KEY
			ZipkinTracer::TraceClient.local_component_span( "External API Call to #{ self }" ) do | ztc |
				api_request_time = Benchmark.realtime do
					request = APIRequest.new( :generic, DOMAIN_SPORT_DATA )
					puts "url::"+ url.to_s
					response = request.for( :get, url, '')
					puts "response.body::"+ response.body.to_s
					response_back = XMLparser.process_xml_response_for_detailed_article response.body.to_s
					parse_response(response_back, sport, action)
				end
			end
			sleep 1
			response_back
		end
		titels_response
	end

	def DirectDataFactory.parse_response(response, league, action)
		if response == nil
			return
		end
		parsed_json = JSON.parse(response)
		parsed_json.each do | preview|
			competition_id = preview['competition_id']
			article_id = preview['article_id']
			competition_date = preview['competition_date']
			author = preview['author']
			source = preview['source']
			publication_date = preview['publication_date']
			title = preview['title']
			synopsis = preview['synopsis']
			body = preview['body']

			puts "publication_date = "+publication_date.to_s

			case action
			when "preview" then
				DirectDBHelperPreview._save_preview(competition_id, article_id, 
					competition_date, author, source, publication_date, title, synopsis, body, league, nil, nil)
			when "recap" then
				DirectDBHelperRecap._save_recap(competition_id, article_id, 
					competition_date, author, source, publication_date, title, synopsis, body, league, nil, nil)
			when "headlines" then
				DirectDBHelperHeadlines._save_headlines(article_id, publication_date, author, source, title,
					synopsis, body, league)
			end
		end
	end

end