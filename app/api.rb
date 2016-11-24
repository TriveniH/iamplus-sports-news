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
  response = news.get_data.to_json

  error_response = set_status response
  if error_response != nil
    return error_response.to_json
  end

  return response.to_json
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
  errorCode = parsedResponse['stat_error_code']
  error_status = parsedResponse['stat_status']
  if errorCode != nil
    status errorCode
    return {status: errorCode,
            stat_status: error_status}
  end
  return nil
end