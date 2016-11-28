module DBHelper

	def DBHelper._save_news(eventId, timeTaken, dateTime, 
			dateType, imageUrl, headline, paragraphs, leagueName)
		SavedGame.create( event_id: eventId,
						time_taken: timeTaken,
						date: dateTime,
						date_type: dateType,
						image_url: imageUrl,
						headline: headline,
						paragraphs: paragraphs,
						league_name: leagueName
				)
	end

	def DBHelper._retrieve_news eventId
		if _check_if_exists(eventId)
			SavedGame.find_by(event_id: eventId) do | savedGame|
				saved_game_json = create_json_from_db savedGame
				return saved_game_json
			end
		else
			puts "entry doesnt exist"
			return nil
		end
	end

	def DBHelper._check_if_exists(eventId)
		return SavedGame.where(event_id: eventId).exists?
	end

	def DBHelper._return_dummy_data_for_league(leagueName)
		SavedGame.find_by(league_name: leagueName) do | game |
			saved_game_json = create_json_from_db game
			return saved_game_json
		end
	end

	def DBHelper.create_json_from_db savedGame
		timeTaken = savedGame[:time_taken]
		date = savedGame[:date]
		dateType = savedGame[:date_type]
		eventId = savedGame[:event_id]
		imageUrl = savedGame[:image_url]
		headline = savedGame[:headline]
		paragraphs = savedGame[:paragraphs]
		content = {paragraphs: paragraphs}
		saved_game_json = {
			status: "OK",
			timeTaken: timeTaken,
			date: date,
			dateType: dateType,
			eventId: eventId,
			imageUrl: imageUrl == nil ? nil : imageUrl,
			headline: headline,
			content: content
		}
		return saved_game_json
	end
end