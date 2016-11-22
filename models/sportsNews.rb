class SportsNews
	def initialize game_Id
    @gameId = game_Id
  	end

	 def resolve_endpoints(gameId)
	 	status = get_game_status(gameId)
	 	if status >0
	 		# completed match
	 	elsif status < 0
	 		# not started yet
	 	else
	 		# in-progress
	 	end
	 	
	 end

	 def get_recap_of_game
	 	mlbnews = MLBNews.new
	 	mlbnews.get_recap_of_game1(@gameId)
	 end

	 def get_preview_of_game
	 	mlbnews = MLBNews.new
	 	mlbnews.get_preview_of_game(@gameId)
	 end

	 def get_game_bullets(gameId = "1677896")
	 end
end