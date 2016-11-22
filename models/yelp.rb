class Yelp
  extend Cacheable
  
  DOMAIN = 'http://api.yelp.com'

  class << self
    def search_for params
      cache = get_cache( cache_key_for( params ))

      if cache
        return JSON.parse( cache, symbolize_names:true )
      end

      response = nil
      api_request_time = Benchmark.realtime do
        request = APIRequest.new( :oauth1, DOMAIN )
        response = request.for( :get, '/v2/search', request_params_for( params ))
      end

      body = response.body
      set_cache cache_key_for( params ), body

      parsed = JSON.parse( body, symbolize_names:true )

      add_entity_ids_to parsed[ :businesses ]

      parsed.merge( api_request_time:api_request_time )
    end


    private

    def request_params_for params
      { location:params[ :location ],
        category_filter:params[ :query ],
        limit:LIMIT }
    end

    def cache_key_for params
      return if params[ :not_cached ]

      "search-#{ params.sort.to_h.values.join '-' }-#{ LIMIT }"
    end

    def add_entity_ids_to ary
      ary.each do |item|
        item[ :entity_id ] = SecureRandom.uuid
      end
    end
  end
end