describe Yelp do
  let( :params    ){{ query:'sushi', location:'los angeles' }}
  let( :cache_key ){ 'search-los angeles-sushi-5' }

  specify 'caches' do
    Yelp.search_for params

    expect( Redis.new.get( cache_key )).to eq yelp_response
  end

  specify 'Response time' do
    expect( Yelp.search_for( params )[ :api_request_time ]).to be > 0
  end

  describe 'Counts API requests' do
    let( :api_requests ){ APIRequestCounter.where( domain:Yelp::DOMAIN, path:'/v2/search' )}
    
    specify do
      Yelp.search_for params

      expect( api_requests.count ).to eq 1
    end
  end
end