class SportsNews
	def initialize params
    @gameId = params[:event_id].to_s
    @sportId = params[:sport].to_s
    @status = params[:event_status_id].to_s
    @teamId = params[:team_id].to_s
    resolve_endpoints
  	end

	 def resolve_endpoints
	 	@gameType = nil
	 	case @sportId
	 	when "MLB" then
	 		@gameType = MLBNews.new
	 	when "NBA" then 
	 		@gameType = NBANews.new
	 	when "NFL" then 
	 		@gameType = NFLNews.new
	 	when "EPL" then 
	 		@gameType = EPLNews.new
	 	end
	 	resolve_action
	 end

	 def get_data
	 	puts "action: "+ @action.to_s
	 	case @action
	 	when Constants::ACTION_PREVIEW then
	 		@gameType.get_preview_of_game(@gameId)
	 	when Constants::ACTION_RECAP then
	 		@gameType.get_recap_of_game(@gameId)
	 	when Constants::ACTION_HEADLINES then
	 		@gameType.get_headlines_for_sport
	 	when Constants::ACTION_RECENT_STORIES_BY_TEAM then
	 		@gameType.get_recent_stories_for_team
	 	end
	 end

	 def resolve_action
	 	if !Utils.is_present?(@status)
	 		@status = nil
	 	end
	 	if !Utils.is_present?(@teamId)
	 		@teamId = nil
	 	end
	 	if !Utils.is_present?(@gameId)
	 		@gameId = nil
	 	end
	 	if @gameId != nil
	 		if @status == nil || @status != "4"
	 			@action = Constants::ACTION_PREVIEW
	 		else
	 			@action = Constants::ACTION_RECAP
	 		end
	 	elsif @teamId != nil
	 		@action = Constants::ACTION_RECENT_STORIES_BY_TEAM
	 	elsif @teamId == nil && @gameId == nil
	 		@action = Constants::ACTION_HEADLINES
	 	end
	 end

end