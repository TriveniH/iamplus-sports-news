LIMIT = 5

before do
  content_type 'application/json'
end

get '/' do
  {status: "WELCOME TO SPORTS-NEWS!!!!"}.to_json
end

get '/sports_news' do
  puts params.to_s
  error_status = check_for_sport_Id
  if error_status != nil
    return error_status.to_json
  end

  news = SportsNews.new(params)
  response = news.get_data.to_json

  error_response = set_status response
  if error_response != nil
    return error_response.to_json
  end

  return response
end

def check_for_sport_Id
  sportId = params[:sport]
  if sportId == nil || sportId.to_s.strip == ''
    status "400"
    return {status: "missing sport Name"}
  end
  return nil
end

def set_status response
  parsedResponse = JSON.parse(response)
  statStatus = parsedResponse['stat_status']
  if statStatus == nil
    return nil
  end

  errorCode = statStatus['stat_error_code']
  error_status = statStatus['stat_message']

  if errorCode != nil
    status errorCode
  end
  return nil
end