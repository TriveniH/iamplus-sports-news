module DBHelperNFLSeason

	def DBHelperNFLSeason._save_season(eventIdList, startDateList, team1IdList, team2IdList)
		puts "eventIdList.length::"+eventIdList.length.to_s
		index = 0
		eventIdList.each do | eventId|
			SavedSeasonNFL.create(event_id: eventId,
				date: startDateList[index],
				team1: team1IdList[index],
				team2: team2IdList[index])
			index += 1
		end
	end

	def DBHelperNFLSeason._get_event_ids_for_preview
		eventIdList = []
		SavedSeasonNFL.where(date:(1.month.ago..2.days.from_now)).each do |s|
  			eventIdList << s['event_id']
		end
		puts "nfl preview eventIdList::"+ eventIdList.length.to_s
		eventIdList
	end


	def DBHelperNFLSeason._get_event_ids_for_recap
		eventIdList = []
		SavedSeasonNFL.where(date:(1.month.ago..Time.now)).each do |s|
			eventIdList << s['event_id']
		end
		puts "NFL:: recap list:"+ eventIdList.length.to_s
		eventIdList
	end
end