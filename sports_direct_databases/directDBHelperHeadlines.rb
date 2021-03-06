module DirectDBHelperHeadlines

	def DirectDBHelperHeadlines._save_headlines(articleId, publicationDate,
	 author, source, title, synopsis, body, leagueName, teamId, teamName)
		DirectSavedHeadLines.create(article_id: articleId,
						publication_date: publicationDate,
						author: author,
						source: source,
						title: title,
						synopsis: synopsis,
						body: body,
						league_name: leagueName,
						team_id: teamId,
						team_name: teamName
				)
	end

	def DirectDBHelperHeadlines._retrieve_headlines(leagueName)
		puts "league name = "+leagueName.to_s
		date = nil
		author = nil
		source = nil
		if _check_if_league_exists(leagueName)
			headlinesList = []
			DirectSavedHeadLines.where(league_name: leagueName).each do | savedHeadLines|

				date = savedHeadLines[:publication_date]
				puts "bhai date = ................."+date.to_s
				author = savedHeadLines[:author]
				source = savedHeadLines[:source]

				headlines_response = create_json_from_db_for_headlines_list savedHeadLines
				puts "headlines_response === "+headlines_response.to_s
				headlinesList << headlines_response
				
			end

			saved_game_json = {
			status: "OK",
			date: date,
			source: source,
			author: author,
			content: headlinesList
			}
			return saved_game_json
		else
			puts "entry doesnt exist"
			return nil
		end
	end

	def DirectDBHelperHeadlines._retrieve_team_news(teamId)
		puts "team id .......= "+teamId.to_s
		date = nil
		author = nil
		source = nil
		team_name = nil
		if _check_if_teamId_exists(teamId)
			headlinesList = []
			DirectSavedHeadLines.where(team_id: teamId).each do | savedHeadLines|

				date = savedHeadLines[:publication_date]
				team_name = savedHeadLines[:team_name]
				puts "team name = "+team_name.to_s

				headlines_response = create_json_from_db_for_headlines_list savedHeadLines
				puts "team_news_response === "+headlines_response.to_s
				headlinesList << headlines_response
				
			end

			saved_game_json = {
			status: "OK",
			date: date,
			source: source,
			author: author,
			team_name: team_name,
			content: headlinesList
			}
			return saved_game_json
		else
			puts "entry doesnt exist"
			return nil
		end
	end

	def DirectDBHelperHeadlines._check_if_league_exists(leagueName)
		return DirectSavedHeadLines.where(league_name: leagueName).exists?
	end

	def DirectDBHelperHeadlines._check_if_teamId_exists(teamId)
		return DirectSavedHeadLines.where(team_id: teamId).exists?
	end

	def DirectDBHelperHeadlines.create_json_from_db_for_headlines_list savedHeadLines
		headlines = savedHeadLines[:title]
		synopsis =  savedHeadLines[:synopsis]
		body = savedHeadLines[:body]
		 {
		 	headlineText:headlines,
			synopsis:synopsis,
			body:body
		}
	end

	def DirectDBHelperHeadlines.clearAllHeadlines
		DirectSavedHeadLines.where(league_name: "NBA").delete
=begin
		DirectSavedHeadLines.where(league_name: "EPL").delete
		DirectSavedHeadLines.where(league_name: "NFL").delete
		DirectSavedHeadLines.where(league_name: "MLB").delete
		DirectSavedHeadLines.where(league_name: "NHL").delete
=end	
	end
end