class SportsNews
	def initialize params
    @gameId = params[:game_id]
    @sportId = params[:sport_id]
    resolve_endpoints
  	end

	 def resolve_endpoints
	 	puts "gameId::"+ @gameId
	 	puts "sportId::"+ @sportId
	 	@gameType = nil
	 	case @sportId
	 	when "1" then
	 		puts "initializing mlbObject"
	 		@gameType = MLBNews.new
=begin
	 	when 2 then
	 		gameType = MLBNews.new
	 	when 3 then
	 		gameType = MLBNews.new
	 	else
	 		gameType = MLBNews.new
=end
	 	end
	 end

	 def get_recap_of_game
	 	mlbnews = MLBNews.new
	 	mlbnews.get_recap_of_game1(@gameId)
	 end

	 def get_preview_of_game
	 	@gameType.get_preview_of_game(@gameId)
	 end

	 def get_game_bullets(gameId = "1677896")
	 end
end