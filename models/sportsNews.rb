class SportsNews
	def initialize params
    @gameId = params[:event_id].to_s
    @sportId = params[:sport].to_s
    @status = params[:event_status_id].to_s
    @teamId = params[:team_id].to_s
    @vendor = params[:vendor].to_s
	resolve_data_vendor
  	end

	 def resolve_endpoints_stats
	 	resolve_action
	 	@gameType = nil
	 	case @sportId
	 	when "MLB" then
	 		@gameType = MLBNews.new(@action)
	 	when "NBA" then 
	 		@gameType = NBANews.new(@action)
	 	when "NFL" then 
	 		@gameType = NFLNews.new(@action)
	 	when "EPL" then 
	 		@gameType = EPLNews.new(@action)
	 	end
	 end

	 def resolve_endpoints_gracenote
	 	resolve_action
 		@gameType = SportsDirectDatafetcher.new(@action)
	 end

	 def resolve_data_vendor
	 	puts "vendor::"+ @vendor.to_s
	 	if @vendor != nil && @vendor.length >0 && @vendor == "gracenote"
			resolve_endpoints_gracenote
			return
	 	end
	 	resolve_endpoints_stats
	 end

	 def get_data
	 	puts "action: "+ @action.to_s
	 	case @action
	 	when Constants::ACTION_PREVIEW then
	 		@gameType.get_preview_for_user_query(@gameId)
	 	when Constants::ACTION_RECAP then
	 		@gameType.get_recap_for_user_query(@gameId)
	 	when Constants::ACTION_HEADLINES then
	 		@gameType.get_headlines_for_sport
	 	when Constants::ACTION_RECENT_STORIES_BY_TEAM then
	 		@gameType.get_recent_stories_for_team @teamId
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
	 	elsif @teamId != nil && @teamId.to_s.strip != ''
	 		@action = Constants::ACTION_RECENT_STORIES_BY_TEAM
	 	elsif (@teamId == nil || @teamId.to_s.strip == '')  && (@gameId == nil || @gameId.to_s.strip == '')
	 		@action = Constants::ACTION_HEADLINES
	 	end
	 end

end