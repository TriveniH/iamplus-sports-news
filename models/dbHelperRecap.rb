module DBHelperRecap

	def DBHelperRecap._save_recap(eventId, dateTime, 
			dateType, imageUrl, headline, paragraphs, leagueName)
		SavedGameRecap.create( event_id: eventId,
						date: dateTime,
						date_type: dateType,
						image_url: imageUrl,
						headline: headline,
						paragraphs: paragraphs,
						league_name: leagueName
				)
	end

	def DBHelperRecap._retrieve_recap eventId
		if _check_if_exists(eventId)
			SavedGameRecap.find_by(event_id: eventId) do | savedGame|
				saved_game_json = create_json_from_db savedGame
				return saved_game_json
			end
		else
			puts "entry doesnt exist"
			return nil
		end
	end

	def DBHelperRecap._check_if_exists(eventId)
		return SavedGameRecap.where(event_id: eventId).exists?
	end

	def DBHelperRecap._return_dummy_data_for_league(leagueName)
		SavedGameRecap.find_by(league_name: leagueName) do | game |
			saved_game_json = create_json_from_db game
			return saved_game_json
		end
		return nil
	end

	def DBHelperRecap.create_json_from_db savedGame
		date = savedGame[:date]
		dateType = savedGame[:date_type]
		eventId = savedGame[:event_id]
		imageUrl = savedGame[:image_url]
		headline = savedGame[:headline]
		paragraphs = savedGame[:paragraphs]
		content = {paragraphs: paragraphs}
		saved_game_json = {
			status: "OK",
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