
# all stubs related to headlines
def stub_headlines
  response = File.read( 'spec/shared/stats_responses/epl_headlines.json' )

  	WebMock.stub_request(:get,  %r{http://api.stats.com/v1/editorial/soccer/epl/stories/headlines/+})
        .to_return( status:200,
                    body:  response,
                    headers:{ 'Content-Type': 'application/json' })


  	WebMock.stub_request(:get,  %r{http://api.stats.com/v1/editorial/baseball/mlb/stories/headlines/+})
        .to_return( status:200,
                    body:  response,
                    headers:{ 'Content-Type': 'application/json' })

  	WebMock.stub_request(:get,  %r{http://api.stats.com/v1/editorial/basketball/nba/stories/headlines/+})
        .to_return( status:200,
                    body:  response,
                    headers:{ 'Content-Type': 'application/json' })
	WebMock.stub_request(:get,  %r{http://api.stats.com/v1/editorial/football/nfl/stories/headlines/+})
        .to_return( status:200,
                    body:  response,
                    headers:{ 'Content-Type': 'application/json' })
end

# all stubs related to teamnews
def stub_team_news
	response = File.read( 'spec/shared/stats_responses/epl_team_news.json' )

	WebMock.stub_request(:get,  %r{http://api.stats.com/v1/editorial/soccer/epl/stories/recent/teams/6145*})
        .to_return( status:200,
                    body:  response,
                    headers:{ 'Content-Type': 'application/json' })
end

def stub_seasons_2016

  response = File.read( 'spec/shared/stats_responses/epl_season_2016.json' )
  WebMock.stub_request(:get,  %r{http://api.stats.com/v1/stats/soccer/epl/scores/+})
        .to_return( status:200,
                    body:  response,
                    headers:{ 'Content-Type': 'application/json' })

  nba_response = File.read( 'spec/shared/stats_responses/nba_season_2016.json' )
  WebMock.stub_request(:get,  %r{http://api.stats.com/v1/stats/basketball/nba/scores/+})
        .to_return( status:200,
                    body:  nba_response,
                    headers:{ 'Content-Type': 'application/json' })

  mlb_response = File.read( 'spec/shared/stats_responses/mlb_season_2016.json' )
  WebMock.stub_request(:get,  %r{http://api.stats.com/v1/stats/baseball/mlb/scores/+})
        .to_return( status:200,
                    body:  mlb_response,
                    headers:{ 'Content-Type': 'application/json' })

  nfl_response = File.read( 'spec/shared/stats_responses/nfl_season_2016.json' )
  WebMock.stub_request(:get,  %r{http://api.stats.com/v1/stats/football/nfl/scores/+})
        .to_return( status:200,
                    body:  nfl_response,
                    headers:{ 'Content-Type': 'application/json' })

end

def stubs_preview
  response = File.read( 'spec/shared/stats_responses/preview_response.json' )
  WebMock.stub_request(:get,  %r{http://api.stats.com/v1/editorial/soccer/epl/stories/previews/events/+})
        .to_return( status:200,
                    body:  response,
                    headers:{ 'Content-Type': 'application/json' })
  WebMock.stub_request(:get,  %r{http://api.stats.com/v1/editorial/soccer/epl/stories/recaps/events/+})
        .to_return( status:200,
                    body:  response,
                    headers:{ 'Content-Type': 'application/json' })

  WebMock.stub_request(:get,  %r{http://api.stats.com/v1/editorial/baseball/mlb/stories/previews/events/+})
        .to_return( status:200,
                    body:  response,
                    headers:{ 'Content-Type': 'application/json' })
  WebMock.stub_request(:get,  %r{http://api.stats.com/v1/editorial/baseball/mlb/stories/recaps/events/+})
        .to_return( status:200,
                    body:  response,
                    headers:{ 'Content-Type': 'application/json' })

  WebMock.stub_request(:get,  %r{http://api.stats.com/v1/editorial/football/nfl/stories/previews/events/+})
        .to_return( status:200,
                    body:  response,
                    headers:{ 'Content-Type': 'application/json' })
  WebMock.stub_request(:get,  %r{http://api.stats.com/v1/editorial/football/nfl/stories/recaps/events/+})
        .to_return( status:200,
                    body:  response,
                    headers:{ 'Content-Type': 'application/json' })

  WebMock.stub_request(:get,  %r{http://api.stats.com/v1/editorial/basketball/nba/stories/previews/events/+})
        .to_return( status:200,
                    body:  response,
                    headers:{ 'Content-Type': 'application/json' })
  WebMock.stub_request(:get,  %r{http://api.stats.com/v1/editorial/basketball/nba/stories/recaps/events/+})
        .to_return( status:200,
                    body:  response,
                    headers:{ 'Content-Type': 'application/json' })

end
