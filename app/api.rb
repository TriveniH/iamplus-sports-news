LIMIT = 5

before do
  content_type 'application/json'
end

get '/sports_news' do
  news = SportsNews.new("1677896")
  news.get_preview_of_game.to_json
end

post '/search' do
  response = Yelp.search_for( get_params )

  save_query

  api_request_time = response.delete( :api_request_time )
  
  { response_data: response,
    ExternalApiRequestTime: { Yelp:api_request_time }}.to_json
end

post '/format' do
  # response_data is buried in one entity. Search for it.
  entity = params[ :mentions ][ :entity ].find{| entity | entity[ :response_data ].present? }
  response_data = entity[ :response_data ]

  format_entities_for( response_data ).to_json
end

def format_entities_for response_data
  cards_data = response_data[ :businesses ].map do | business |
    address = business[ :location ][ :address ].join( ' ' )

    { Name: 'NewsCardList',
      Id: 'UIVerticalList',
      Title:      business[ :name ],
      Rating:     business[ :rating ],
      SpeakOut:   "#{ business[ :name ]} is located at #{ address }",
      ShowSpeech: business[ :name      ],
      ImageUrl:   business[ :image_url ]}
  end

  { IntroSpeakOut: 'Here are the results of your search.',
    IntroShowSpeech: 'Here are the results of your search.',
    AutoListen: true,
    CardsData: cards_data }
end

def get_params
  ps = @params[ :nlu_response ][ :mentions ].map do | h |
    k = h[ :field_id ].to_sym
    v = h[ :value    ]

    { k => v }
  end.reduce( :merge )
     
  ps.merge!( not_cached:@params[ :not_cached ]) if @params[ :not_cached ]

  ps
end

def save_query
  user = Identity.user_from_token( params.dig :user_data, :identity_token )
  user_uuid = user[ :user_uuid ]
  SavedQuery.create( user_uuid:user_uuid,
                     query:    get_params[ :query    ],
                     location: get_params[ :location ])
end