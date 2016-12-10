module DBHelperEPLSeason

	def DBHelperEPLSeason._save_season(eventIdList, startDateList, team1IdList, team2IdList)
		puts "eventIdList.length::"+eventIdList.length.to_s
		index = 0
		eventIdList.each do | eventId|
			SavedSeasonEPL.create(event_id: eventId,
				date: startDateList[index],
				team1: team1IdList[index],
				team2: team2IdList[index])
			index += 1
		end
	end

	def DBHelperEPLSeason._get_event_ids_for_preview
		eventIdList = []
		SavedSeasonEPL.where(date:(1.month.ago..1.month.from_now)).each do |s|
			eventIdList << s['event_id']
		end
		puts "eventIdList for recap:: "+ eventIdList.length.to_s
		eventIdList
	end

	def DBHelperEPLSeason._get_event_ids_for_recap
		eventIdList = []
		SavedSeasonEPL.where(date:(1.month.ago..Time.now)).each do |s|
			eventIdList << s['event_id']
		end
		puts "eventIdList for recap:: "+ eventIdList.length.to_s
		eventIdList
	end
end