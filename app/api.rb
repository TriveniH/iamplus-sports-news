LIMIT = 5

before do
  content_type 'application/json'
end

get '/' do
  {status: "WELCOME TO SPORTS-NEWS!!!!"}.to_json
end

get '/sports_news' do
  response = nil
  ZipkinTracer::TraceClient.local_component_span( "External API Call to #{ self }" ) do | ztc |
    totalProcessTimeInMilli = Benchmark.ms do
      eventIds = params[:event_ids]
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
    end
  end
  return response
end

def check_for_sport_Id
  sportId = params[:sport]
  if sportId == nil || sportId.to_s.strip == ''
    status "400"
    return {status_message: "Missing sport Name in the request."}
  elsif !Constants::SUPPORTED_SPORTS.include?(sportId)
        status "400"
    return {status_message: "Invalid sport Name in the request."}
  end
  return nil
end

def set_status response
  parsedResponse = JSON.parse(response)
  statStatus = parsedResponse['error_status']
  if statStatus == nil
    return nil
  end

  errorCode = statStatus['error_code']
  error_status = statStatus['message']

  if errorCode != nil
    status errorCode
  end
  return nil
end