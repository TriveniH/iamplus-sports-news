module DBHelperPreview

	def DBHelperPreview._save_preview(eventId, dateTime, 
			dateType, imageUrl, headline, paragraphs, leagueName)
		SavedGamePreview.create( event_id: eventId,
						date: dateTime,
						date_type: dateType,
						image_url: imageUrl,
						headline: headline,
						paragraphs: paragraphs,
						league_name: leagueName
				)
	end

	def DBHelperPreview._retrieve_preview eventId
		if _check_if_exists(eventId)
			SavedGamePreview.find_by(event_id: eventId) do | savedGame|
				saved_game_json = create_json_from_db savedGame
				return saved_game_json
			end
		else
			puts "entry doesnt exist"
			return nil
		end
	end

	def DBHelperPreview._check_if_exists(eventId)
		return SavedGamePreview.where(event_id: eventId).exists?
	end

	def DBHelperPreview._return_dummy_data_for_league(leagueName)
		SavedGamePreview.find_by(league_name: leagueName) do | game |
			saved_game_json = create_json_from_db game
			return saved_game_json
		end
		return nil
	end

	def DBHelperPreview.create_json_from_db savedGame
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