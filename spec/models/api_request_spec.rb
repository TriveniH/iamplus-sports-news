describe APIRequest do
  describe 'Oauth 2' do
    let( :api_request ){ APIRequest.new :oauth2, 'http://auth-staging.i.am' }

    before do
      WebMock.stub_request( :get, "http://auth-staging.i.am/api/account" )
           .with( :body => "{}",
                  :headers => {'Authorization'=>"Bearer #{ ENV[ 'OAUTH2_ACCESS_TOKEN' ]}" }).
           to_return(:status => 200, :body => "", :headers => {})
    end

    specify 'success' do
      api_request.for :get, '/api/account', {}

      expect( WebMock ).to have_requested( :get, "http://auth-staging.i.am/api/account" )
                           .with( body:"{}", headers:{ 'Authorization' => "Bearer #{ ENV[ 'OAUTH2_ACCESS_TOKEN' ]}" })
    end
  end

  describe 'Generic' do
    let( :api_request ){ APIRequest.new :generic, 'http://example.com', Authorization:'Authorization' }

    before do
      WebMock.stub_request( :post, "http://example.com/path" )
             .to_return(:status => 200, :body => "", :headers => {})
    end

    specify 'success' do
      api_request.for :post, '/path', 'body'

      expect( WebMock ).to have_requested( :post, "http://example.com/path" )
                           .with( body:"body", headers:{ 'Authorization' => "Authorization" })
    end
  end
end