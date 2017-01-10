module JsonUtils

def JsonUtils.process_response_action_based(response, api_key, secret, domain, route, action)
		puts "action in jsonUtils::"+ action.to_s
		#puts "response before processing:"+ response.to_s
		response_back = nil
		case action
		 	when Constants::ACTION_PREVIEW then
		 		response_back = process_response(response, api_key, secret, domain, route)
	 		when Constants::ACTION_RECAP then
	 			response_back = process_response(response, api_key, secret, domain, route)
	 		when Constants::ACTION_HEADLINES then
	 			#puts "response::---------"+ response.to_s
	 			response_back = process_response_for_headlines(response, api_key, secret, domain, route, action)
	 		when Constants::ACTION_RECENT_STORIES_BY_TEAM then
	 			response_back = process_response_for_headlines(response, api_key, secret, domain, route, action)
	 	end
	 	response_back
end

def JsonUtils.make_api_request_generic(url, action, api_key, secret, domain, route)
	response_back = nil
	ZipkinTracer::TraceClient.local_component_span( "External API Call to #{ self }" ) do | ztc |
		api_request_time = Benchmark.realtime do
			request = APIRequest.new( :generic, domain )
			puts "url::"+ url.to_s
			response = request.for( :get, url, '')
			request_status = Utils.check_response_status response
			if request_status != nil
				return request_status
			end
			#puts "response.body::"+ response.body.to_s
			response_back = process_response_action_based(response.body, api_key, secret, domain, route, action)
		end
	end
	return response_back
end

def JsonUtils.process_response(response, api_key, secret, domain, route)
		parsedJson = JSON.parse(response)
		status = parsedJson["status"]
		timeTaken = parsedJson["timeTaken"]
		results = parsedJson["apiResults"]
		date = nil
		dateType = nil
		eventId = nil
		imageUrl = nil
		headline = nil
		content = nil
		results.each do | result|
			story = result["league"]["story"]
			date = story["publishDate"]["full"]
			dateType = story["publishDate"]["dateType"]
			eventId = story["eventId"]
			images = story["images"]
			if images != nil && images.length >0
				imageId = nil
				images.each do |image|
					imageId = image["imageId"]
				end
				imageUrl = getImageUrl(imageId, api_key, secret, domain, route)
			end
			headline = story["header"]["headline"]
			content = story["content"]
		end

		{
			status: status,
			timeTaken: timeTaken,
			date: date,
			dateType: dateType,
			eventId: eventId,
			imageUrl: imageUrl == nil ? nil : imageUrl,
			headline: headline,
			content: content
		}
	end

	def JsonUtils.getImageUrl(imageId, api_key, secret, domain, route)
		event_url = "images/p128/"+imageId+"/?"
		sig = Utils.get_api_key_signature_string(api_key, secret, nil)
		imageUrl = domain + route + event_url + sig
		puts "imageUrl:: "+ imageUrl
		return imageUrl
	end

	def JsonUtils.process_response_for_headlines(response, api_key, secret, domain, route, action)
		#puts "response::"+ response.to_s
		parsedJson = JSON.parse(response)
		status = parsedJson["status"]
		timeTaken = parsedJson["timeTaken"]
		results = parsedJson["apiResults"]
		date = nil
		dateType = nil
		headlineObjects = []

		headlineText = nil
		teamId = nil
		puts "results::"+ results.to_s
		puts "results::"+ results.length.to_s
		results.each do | result|
			teamId = get_team_id(result["league"], action)
			headlinePackage = resolveHeadlinePackage(result["league"], action)
			date = headlinePackage["publishDate"]["full"]
			dateType = headlinePackage["publishDate"]["dateType"]
			headlines = headlinePackage["headlines"]
			headlines.each do | headline|
				headlineText = headline["headlineText"]
				images = headline["images"]
				imageUrl = nil
				if images != nil && images.length >0
					imageId = nil
					images.each do |image|
						imageId = image["imageId"]
						puts "imageId:"	+ imageId.to_s		
					end
					imageUrl = getImageUrl(imageId, api_key, secret, domain, route)
				end
				headlineObjects << HeadLine.new(headlineText, imageUrl)				
			end
		end

		responseList = headlineObjects.map do |headlineObject| 
			{
				headlineText: headlineObject.headLineText,
				imageUrl: headlineObject.imageUrl == nil ? nil : headlineObject.imageUrl
			}
		end
		#puts "responseList:: "+ responseList.to_s
		finalresponse = {
			status: status,
			timeTaken: timeTaken,
			date: date,
			dateType: dateType,
			headlines: responseList,
			team_id: teamId
		}
		#puts "response: "+ finalresponse.to_s
		finalresponse
	end

class HeadLine
	attr_accessor :headLineText,
				  :imageUrl

	def initialize(headLineText, imageUrl)
		@headLineText = headLineText
		@imageUrl = imageUrl
	end
end

def JsonUtils.resolveHeadlinePackage(league, action)
	headlinePackage = nil
	case action
	when Constants::ACTION_RECENT_STORIES_BY_TEAM then
		headlinePackage = league["team"]["headlinePackage"]
	else
		headlinePackage = league["headlinePackage"]	
	end
	headlinePackage
end

def JsonUtils.get_team_id(league, action)
	if action == Constants::ACTION_RECENT_STORIES_BY_TEAM
		return league["team"]["teamId"]
	end
	return nil
end

end
