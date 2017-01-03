module DBHelperHeadLines
	def DBHelperHeadLines._save_headlines(dateTime, dateType,
	 imageUrl, headlines, leagueName, teamId)
		SavedHeadLines.create(publish_date: dateTime,
						date_type: dateType,
						image_url: imageUrl,
						headlines: headlines,
						team_id: teamId,
						league_name: leagueName
				)
	end

	def DBHelperHeadLines._retrieve_headlines(leagueName)
		if _check_if_league_exists(leagueName)
			SavedHeadLines.find_by(league_name: leagueName) do | savedHeadLines|
				saved_game_json = create_json_from_db savedHeadLines
				return saved_game_json
			end
		else
			puts "entry doesnt exist"
			return nil
		end
	end

	def DBHelperHeadLines._retrieve_headlines_for_team(leagueName, teamId)
		#doesn't handle the case of entry not being present, assumes entry for team already present
		SavedHeadLines.find_by(team_id: teamId) do | savedHeadLines|
			saved_game_json = create_json_from_db savedHeadLines
			return saved_game_json
		end
	end

	def DBHelperHeadLines._check_if_league_exists(leagueName)
		return SavedHeadLines.where(league_name: leagueName).exists?
	end

	def DBHelperHeadLines._check_if_league_team_exists(leagueName, teamId)
		if SavedHeadLines.where(league_name: leagueName).exists?
			return SavedHeadLines.where(team_id: teamId).exists?
		end
		return false
	end

	def DBHelperHeadLines.create_json_from_db savedHeadLines
		date = savedHeadLines[:publish_date]
		dateType = savedHeadLines[:date_type]
		imageUrl = savedHeadLines[:image_url]
		headlines = savedHeadLines[:headlines]
		teamId = savedHeadLines[:team_id]
		responseList = headlines.map do |headline| 
			{
				headlineText: headline,
				imageUrl: imageUrl
			}
		end
		puts "responseList:: "+ responseList.to_s
		saved_game_json = {
			status: "OK",
			timeTaken: nil,
			teamId: teamId,
			date: date,
			dateType: dateType,
			headlines: responseList
		}

		return saved_game_json
	end

	def DBHelperHeadLines.clearAllHeadlines
		SavedHeadLines.where(league_name: "EPL").delete
		SavedHeadLines.where(league_name: "NFL").delete
		SavedHeadLines.where(league_name: "MLB").delete
		SavedHeadLines.where(league_name: "NBA").delete
	end
end