module DBHelper

	def DBHelper._save_news(eventId, timeTaken, dateTime, 
			dateType, imageUrl, headline, paragraphs)
		SavedGame.create( event_id: eventId,
						time_taken: timeTaken,
						date: dateTime,
						date_type: dateType,
						image_url: imageUrl,
						headline: headline,
						paragraphs: paragraphs
				)
	end

	def DBHelper._retrieve_news eventId
		if _check_if_exists(eventId)
			SavedGame.find_by(event_id: eventId) do | savedGame|
				timeTaken = savedGame[:time_taken]
				date = savedGame[:date]
				dateType = savedGame[:date_type]
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
		else
			puts "entry doesnt exist"
			return nil
		end
	end

	def DBHelper._check_if_exists(eventId)
		return SavedGame.where(event_id: eventId).exists?
	end
end