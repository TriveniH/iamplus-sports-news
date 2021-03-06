module DBHelperRecap

	def DBHelperRecap._save_recap(eventId, dateTime, 
			dateType, imageUrl, headline, paragraphs, leagueName, errorCode, errorMessage)
		SavedGameRecap.find_by(event_id: eventId) do | savedGame|
				errorCodeGame = savedGame[:error_code]
				if errorCodeGame != nil && errorCode == nil
					update_event(eventId, dateTime, 
						dateType, imageUrl, headline, paragraphs, leagueName)
				end
		end
		SavedGameRecap.create( event_id: eventId,
						date: dateTime,
						date_type: dateType,
						image_url: imageUrl,
						headline: headline,
						paragraphs: paragraphs,
						league_name: leagueName,
						error_code:errorCode,
						error_message:errorMessage
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


	def DBHelperRecap._check_if_retry_needed(eventId)
		if _check_if_exists eventId
			SavedGameRecap.find_by(event_id: eventId) do | savedGame|
				errorCode = savedGame[:error_code]
				if errorCode != nil
					return true
				end
			end
			#means entry exists with no error
			return false
		end
		#means entry doesnt exists, needs to pull
		return true
	end

	def DBHelperRecap._return_dummy_data_for_league(leagueName)
		SavedGameRecap.find_by(league_name: leagueName) do | game |
			saved_game_json = create_json_from_db game
			return saved_game_json
		end
		return nil
	end

	def DBHelperRecap.create_json_from_db savedGame
		errorCode = savedGame[:error_code]
		if errorCode != nil
			return Utils.generate_error_response errorCode.to_i
		end
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

	def DBHelperRecap.update_event(eventId, dateTime, dateType, imageUrl,
				headline, paragraphs, leagueName)
		SavedGameRecap.find_by(event_id: eventId).update(date: dateTime,
						date_type: dateType,
						image_url: imageUrl,
						headline: headline,
						paragraphs: paragraphs,
						league_name: leagueName,
						error_code: nil,
						error_message: nil)
	end

end