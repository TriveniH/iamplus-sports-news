describe DataFactory do

	before do
		stub_seasons_2016
		stub_headlines
		stubs_preview
	end

	specify 'updating seasons database with info available' do
		DataFactory.fetch_update_schedule 2016
	end

	specify 'update previews' do
		#DataFactory.update_previews_recaps
	end

	specify 'pull one preview' do
		DataFactory.update_preview_for_event_id("EPL", "1643241")
		DataFactory.update_preview_for_event_id("MLB", "1677896")
		DataFactory.update_preview_for_event_id("NBA", "1674447")
		DataFactory.update_preview_for_event_id("NFL", "1635749")
	end

	specify 'pull one recap' do
		DataFactory.update_recap_for_event_id("EPL", "1643241")
		DataFactory.update_recap_for_event_id("MLB", "1677891")
		DataFactory.update_recap_for_event_id("NBA", "1674447")
		DataFactory.update_recap_for_event_id("NFL", "1635731")
	end


end