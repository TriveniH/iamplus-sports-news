describe Identity do
  let( :token        ){ 'abc123'   }
  let( :user_uuid    ){ 'user-1234' }
  let( :identity_url ){ "#{ Identity::IDENTITY_DOMAIN }#{ Identity::IDENTITY_PATH }"}

  before do
    WebMock.stub_request( :get, identity_url )
      .with( body:"access_token=#{ token }")
      .to_return( status:    200,
                  headers:{ 'Content-Type' => 'application/json' },
                  body:   {  user_uuid:user_uuid }.to_json        )
  end

  specify 'gets user uuid' do
    user = Identity.user_from_token( token )
    expect( user[ :user_uuid ]).to eq user_uuid
  end

  context 'When no such user returns empty hash' do
    before do
      WebMock.stub_request( :get, identity_url )
        .with( body:"access_token=#{ token }")
        .to_return( status:    404,
                    headers:{ 'Content-Type' => 'application/json' },
                    body:     ''                                    )
    end

    specify 'gets user uuid' do
      user = Identity.user_from_token( token )
      expect( user[ :user_uuid ]).to eq nil
    end
  end
end