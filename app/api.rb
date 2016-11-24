LIMIT = 5

before do
  content_type 'application/json'
end

get '/sports_news' do
  puts params.to_s
  error_status = check_for_sport_Id
  if error_status != nil
    return error_status.to_json
  end
  news = SportsNews.new(params)
  news.get_data.to_json
  #news.get_preview_of_game.to_json
end

def check_for_sport_Id
  sportId = params[:sport]
  if sportId == nil || sportId.to_s.strip == ''
    status "400"
    return {status: "missing sport Name"}
  end
  return nil
end