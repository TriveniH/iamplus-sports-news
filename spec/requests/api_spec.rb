describe 'API Spec' do
  let( :mentions   ){[ { "field_id": "query",
                          "value": "sushi" },
                        { "field_id": "location",
                          "value": "los angeles" } ]}
  let( :params ){{ nlu_response:{
                     mentions:mentions,
                     intent:'search', },
                   user_data:{ 'identity_token': 'abc123' } }}
  let( :expected  ){{ name:'KazuNori', image_url:'https://s3-media3.fl.yelpcdn.com/bphoto/9D63gCmIesyBQO15NNG9Xw/ms.jpg' }}
  let( :cache_key ){ 'search-los angeles-sushi-5' }

  let( :token        ){ 'abc123'   }
  let( :user_uuid    ){ 'user-1234' }
  let( :identity_url ){ "#{ Identity::IDENTITY_DOMAIN }#{ Identity::IDENTITY_PATH }"}

  let( :business_from_yelp ){ JSON.parse( yelp_response, symbolize_names:true )[ :businesses ][ 0 ]}

  before do
    header 'Content-Type', 'application/json'

    WebMock.stub_request( :get, identity_url )
      .with( body:"access_token=#{ token }")
      .to_return( status:    200,
                  headers:{ 'Content-Type' => 'application/json' },
                  body:   {  user_uuid:user_uuid }.to_json        )
  end

  specify 'Search returns Yelp response' do
    post '/search', params.to_json

    expect( parsed_response[ :response_data ][ :businesses ][ 0 ]).to include business_from_yelp
  end

  specify 'Search injects entity ids into businesses' do
    post '/search', params.to_json

    expect( parsed_response[ :response_data ][ :businesses ][ 0 ][ :entity_id ].length ).to eq 36
  end

  describe 'Format' do
    # 1 entity will contain response data. We don't know which one.
    let( :entities ){[{}, { response_data:@response_data }]}

    before do
      post '/search', params.to_json
      @response_data = parsed_response[ :response_data ]
    end

    specify do
      post '/format', { mentions:{ entity:entities }}.to_json

      expect( last_response.status ).to eq 200
      expect( last_response.content_type ).to eq 'application/json'
      expect( parsed_response[ :IntroSpeakOut ]).to eq 'Here are the results of your search.'
      expect( parsed_response[ :CardsData ].count ).to eq 5
      expect( parsed_response[ :CardsData ][ 0 ][ :SpeakOut ]).to eq 'KazuNori is located at 421 S Main St'
      expect( parsed_response[ :CardsData ][ 0 ][ :ImageUrl ]).to eq 'https://s3-media3.fl.yelpcdn.com/bphoto/9D63gCmIesyBQO15NNG9Xw/ms.jpg'
    end
  end

  specify 'Sets cache' do
    post '/search', params.to_json

    expect( Redis.new.get( cache_key )).to eq yelp_response
  end

  specify 'Sets cache expiry' do
    post '/search', params.to_json

    expect( Redis.new.ttl( cache_key )).to eq Cacheable::EXPIRY
  end

  specify 'Gets from cache' do
    post '/search', params.to_json
    post '/search', params.to_json

    expect( WebMock ).to have_requested( :get, %r{http://api.yelp.com/v2/search}).once
  end

  context 'When not_cached is true do not get from cache' do
    specify do
      post '/search', params.to_json
      post '/search', params.merge( not_cached:true ).to_json

      expect( WebMock ).to have_requested( :get, %r{http://api.yelp.com/v2/search}).twice
    end
  end

  describe 'Save recent query for user' do
    specify 'creates' do
      post '/search', params.to_json
      
      expect( last_response.status ).to eq 200

      expect( SavedQuery.count ).to eq 1
      expect( SavedQuery.first.query    ).to eq 'sushi'
      expect( SavedQuery.first.location ).to eq 'los angeles'
      expect( SavedQuery.first.user_uuid ).to eq 'user-1234'
    end

    specify 'uniqueness' do
      post '/search', params.to_json
      post '/search', params.to_json
      
      expect( last_response.status ).to eq 200

      expect( SavedQuery.count ).to eq 1
      expect( SavedQuery.first.query    ).to eq 'sushi'
      expect( SavedQuery.first.location ).to eq 'los angeles'
    end
  end

  describe 'Exposes ExternalApiRequestTime' do
    specify 'Success' do
      post '/search', params.to_json

      expect( parsed_response[ :ExternalApiRequestTime ][ :Yelp ]).to be > 0
      expect( parsed_response[ :ExternalApiRequestTime ][ :Yelp ]).to be < 1
    end
  end
end
