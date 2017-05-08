module DirectDBHelperRecap

	def DirectDBHelperRecap._save_recap(competition_id, article_id, 
			competition_date, author, source, publication_date, title, synopsis, body,league_name, error_code, errorMessage)
			DirectSavedGameRecap.find_by(competition_id: competition_id) do | savedGame|
				errorCodeGame = savedGame[:error_code]
				if errorCodeGame != nil && errorCode == nil
					update_event(competition_id, article_id, competition_date, author,
					source, publication_date, title, synopsis, body,league_name)
				end
			end
		DirectSavedGameRecap.create( competition_id: competition_id,
						article_id: article_id,
						competition_date: competition_date,
						author: author,
						source: source,
						publication_date: publication_date,
						title: title,
						synopsis: synopsis,
						body: body,
						league_name: league_name,
						error_code:error_code,
						error_message:errorMessage
				)
	end

	def DirectDBHelperRecap._retrieve_recap competition_id
		if _check_if_exists(competition_id)
			DirectSavedGameRecap.find_by(competition_id: competition_id) do | savedGame|
				saved_game_json = create_json_from_db savedGame
				return saved_game_json
			end
		else
			puts "entry doesnt exist"
			return nil
		end
	end

	def DirectDBHelperRecap._check_if_exists(competition_id)
		return DirectSavedGameRecap.where(competition_id: competition_id).exists?
	end

	def DirectDBHelperRecap._check_if_retry_needed(eventId)
		if _check_if_exists eventId
			DirectSavedGameRecap.find_by(competition_id: competition_id) do | savedGame|
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

	def DirectDBHelperRecap._return_dummy_data_for_league(leagueName)
		DirectSavedGameRecap.find_by(league_name: leagueName) do | game |
			saved_game_json = create_json_from_db game
			return saved_game_json
		end
		return nil
	end

	def DirectDBHelperRecap.create_json_from_db savedGame
		errorCode = savedGame[:error_code]
		if errorCode != nil
			return Utils.generate_error_response errorCode.to_i
		end
		date = savedGame[:competition_date]
		competition_id = savedGame[:competition_id]
		author = savedGame[:author]
		source = savedGame[:source]
		headlines = savedGame[:title]
		synopsis =  savedGame[:synopsis]
		body = savedGame[:body]
		saved_game_json = {
			status: "OK",
			date: date,
			eventId: competition_id,
			source: source,
			author: author,
			headlines: headlines,
			synopsis: synopsis,
			body: body
		}
		return saved_game_json
	end

	def DirectDBHelperRecap.update_event(competition_id, article_id, competition_date, author,
					source, publication_date, title, synopsis, body,league_name)
		DirectSavedGameRecap.find_by(competition_id: competition_id).update(article_id: article_id,
						competition_date: competition_date,
						author: author,
						source: source,
						publication_date: publication_date,
						title: title,
						synopsis: synopsis,
						body: body,
						league_name: league_name,
						error_code: nil,
						error_message: nil)
	end
end