describe 'API Spec' do
  let( :identity_url ){ "#{ Identity::IDENTITY_DOMAIN }#{ Identity::IDENTITY_PATH }"}

  before do
    header 'Content-Type', 'application/json'
    stub_headlines
    stub_team_news
  end


  describe 'validate sport Name' do
      #for all the sports.
      specify 'check for sport name being nil/empty' do
        get '/sports_news'
        expect( last_response.status).to eq 400
      end

      #checking for invalid sport name
      specify 'check for invalid sport name' do
        get '/sports_news', sport: "CRICKET"
        expect( last_response.status).to eq 400
      end
  end


  describe 'HeadLines' do
    specify 'should return headlines for EPL' do
      get '/sports_news', sport: "EPL"
      expect( last_response.status).to eq 200
      expect( parsed_response[ :headlines ][ 0 ]).not_to be_empty
    end
    specify 'should return headlines for MLB' do
      get '/sports_news', sport: "MLB"
      expect( last_response.status).to eq 200
      expect( parsed_response[ :headlines ][ 0 ]).not_to be_empty
    end
    specify 'should return headlines for NBA' do
      get '/sports_news', sport: "NBA"
      expect( last_response.status).to eq 200
      expect( parsed_response[ :headlines ][ 0 ]).not_to be_empty
    end
    specify 'should return headlines for NFL' do
      get '/sports_news', sport: "NFL"
      expect( last_response.status).to eq 200
      expect( parsed_response[ :headlines ][ 0 ]).not_to be_empty
    end
  end


  describe 'Team news' do
    context 'Team id is nil/empty' do
      specify 'It should verify that it shows HeadLines for sport' do
        get '/sports_news', {sport: "EPL", team_id: ""}

        expect( last_response.status).to eq 200
        expect( parsed_response[ :teamId]).to be_nil
      end
    end
    context 'With Team Id' do
      specify 'it should return team news' do
        get '/sports_news', {sport: "EPL", team_id: "6145"}
        expect( last_response.status).to eq 200
        expect( parsed_response[ :teamId]).to eql "6145"
        expect( parsed_response[ :headlines][0]).not_to be_empty
      end
    end
  end

  describe 'Previews' do
    context 'with valid event id' do
      specify 'when no preview available for the event yet' do
        get '/sports_news', {sport: "EPL", event_id: "1643340"}
        expect( last_response.status ).to eq 404
        expect( parsed_response[ :eventId ]).to be_nil
      end
      specify 'when preview available for the event' do
        get '/sports_news', {sport: "EPL", event_id: "1643241"}
        expect( last_response.status).to eq 200
        expect( parsed_response[ :eventId ]).to eq "1643241"
        expect( parsed_response[ :headline ]).not_to be_nil
        expect( parsed_response[ :content ][ :paragraphs ]).not_to be_empty
        expect( parsed_response[ :content ][ :paragraphs ][0]).not_to be_nil
      end
    end
  end

end
