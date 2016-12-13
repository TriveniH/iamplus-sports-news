module DBHelperMLBSeason

	def DBHelperMLBSeason._save_season(eventIdList, startDateList, team1IdList, team2IdList)
		puts "eventIdList.length::"+eventIdList.length.to_s
		index = 0
		eventIdList.each do | eventId|
			SavedSeasonMLB.create(event_id: eventId,
				date: startDateList[index],
				team1: team1IdList[index],
				team2: team2IdList[index])
			index += 1
		end
	end

	def DBHelperMLBSeason._get_event_ids_for_preview
		eventIdList = []
		SavedSeasonMLB.where(date:(3.months.ago..2.days.from_now)).each do |s|
  			eventIdList << s['event_id']
		end
		puts "MLB:: event list for preview:"+ eventIdList.length.to_s
		eventIdList
	end


	def DBHelperMLBSeason._get_event_ids_for_recap
		eventIdList = []
		SavedSeasonMLB.where(date:(3.months.ago..Time.now)).each do |s|
			eventIdList << s['event_id']
		end
		puts "MLB:: event list for recap:"+ eventIdList.length.to_s
		eventIdList
	end
end