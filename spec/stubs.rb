
# all stubs related to headlines
def stub_headlines
  response = File.read( 'spec/shared/stats_responses/epl_headlines.json' )

  	WebMock.stub_request(:get,  %r{http://api.stats.com/v1/editorial/soccer/epl/stories/headlines/*})
        .to_return( status:200,
                    body:  response,
                    headers:{ 'Content-Type': 'application/json' })


  	WebMock.stub_request(:get,  %r{http://api.stats.com/v1/editorial/baseball/mlb/stories/headlines/*})
        .to_return( status:200,
                    body:  response,
                    headers:{ 'Content-Type': 'application/json' })

  	WebMock.stub_request(:get,  %r{http://api.stats.com/v1/editorial/basketball/nba/stories/headlines/*})
        .to_return( status:200,
                    body:  response,
                    headers:{ 'Content-Type': 'application/json' })
	WebMock.stub_request(:get,  %r{http://api.stats.com/v1/editorial/football/nfl/stories/headlines/*})
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