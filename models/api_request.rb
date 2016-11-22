class APIRequest
  def initialize auth_type, domain, headers={}
    @auth_type = auth_type
    @domain = domain
    @headers = headers
  end

  def for method, path, params
    APIRequestCounter.create( domain:@domain, path:path )

    case @auth_type
    when :oauth1
      oauth1_request method, path, params
    
    when :oauth2
      oauth2_request method, path, params

    when :generic
      generic_request method, path, params

    else
      raise 'Invalid APIRequest auth type'
    end
  end


  private

  def generic_request method, path, params
    uri = "#{ @domain }#{ path }"
    puts "inapirequest:: "+uri
    HTTParty.send method, uri, headers:@headers, body:params
  end

  def oauth2_request method, path, params
    uri = "#{ @domain }#{ path }"
    auth = { 'Authorization' => "Bearer #{ ENV[ 'OAUTH2_ACCESS_TOKEN' ]}"}

    HTTParty.send method, uri, headers:auth, body:params.to_json
  end

  def oauth1_request method, path, params
    url_params = Rack::Utils.build_query( params )

    oauth1_access_token.request method, "#{ path }?#{ url_params }"
  end

  def oauth1_access_token
    consumer = OAuth::Consumer.new( ENV[ 'CONSUMER_KEY' ], ENV[ 'CONSUMER_SECRET' ],
                { site:@domain, signature_method:'HMAC-SHA1', scheme: :header })

    OAuth::AccessToken.new( consumer, ENV[ 'TOKEN' ], ENV[ 'TOKEN_SECRET' ])
  end
end
