class SportsDirectDatafetcher

	def initialize (action, sportId)
		puts "SportsDirectDatafetcher initializing"
		@action = action
		@sportId = sportId
	end

	def get_preview_for_user_query(competition_id)

		if(DirectDBHelperPreview._check_if_exists(competition_id))
			return DirectDBHelperPreview._retrieve_preview(competition_id)
		end
		return Utils.generate_error_response 404
	end

	def get_recap_for_user_query(competition_id)

		if(DirectDBHelperRecap._check_if_exists(competition_id))
			return DirectDBHelperRecap._retrieve_recap(competition_id)
		end
		return Utils.generate_error_response 404
	end

	def get_headlines_for_sport
		if DirectDBHelperHeadlines._check_if_league_exists(@sportId)
			return DirectDBHelperHeadlines._retrieve_headlines(@sportId)
		end
		return Utils.generate_error_response 404
	end
end