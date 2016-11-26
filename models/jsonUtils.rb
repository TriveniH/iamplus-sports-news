module JsonUtils

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
		sig = Utils.get_api_key_signature_string(api_key, secret)
		imageUrl = domain + route + event_url + sig
		puts "imageUrl:: "+ imageUrl
		return imageUrl
	end

	def JsonUtils.process_response_for_headlines(response, api_key, secret, domain, route)
		puts "response::"+ response.to_s
		parsedJson = JSON.parse(response)
		status = parsedJson["status"]
		timeTaken = parsedJson["timeTaken"]
		results = parsedJson["apiResults"]
		date = nil
		dateType = nil
		headlineObjects = []
		headlineText = nil
		results.each do | result|
			headlinePackage = result["league"]["headlinePackage"]
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
		puts "responseList:: "+ responseList.to_s
		finalresponse = {
			status: status,
			timeTaken: timeTaken,
			date: date,
			dateType: dateType,
			headlines: responseList
		}
		puts "response: "+ finalresponse.to_s
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
end
