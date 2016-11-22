LIMIT = 5

before do
  content_type 'application/json'
end

get '/sports_news' do
  puts params.to_s
  news = SportsNews.new(params)
  news.get_preview_of_game.to_json
end