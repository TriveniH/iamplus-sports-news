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

end
