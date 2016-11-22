class Identity
  IDENTITY_DOMAIN = 'https://auth.i.am'
  IDENTITY_PATH   = '/api/account'

  class << self
    def user_from_token token
      request = APIRequest.new( :generic, IDENTITY_DOMAIN )
      response = request.for( :get, IDENTITY_PATH, { access_token:token })

      return {} if ! response.success?

      response.symbolize_keys
    end
  end
end