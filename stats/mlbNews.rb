require 'base64'
require 'cgi'
require 'openssl'
require 'digest'

class MLBNews
	DOMAIN = "http://api.stats.com/"
	ROUTE = "v1/editorial/baseball/mlb/"

	def initialize
	end

	def get_recap_of_game1(gameId = "1677896")
		event_url = "stories/recaps/events/"+gameId +"/?"
		url = ROUTE + event_url + get_api_key_signature_string
		puts "URL::"+ url
		make_api_request url
	end

	def get_preview_of_game(gameId = "1677896")
		event_url = "stories/previews/events/"+gameId +"/?"
		url = ROUTE + event_url + get_api_key_signature_string
		puts "URL::"+ url
		make_api_request url
	end

	def get_game_bullets(gameId = "1677896")
	end

	def get_api_key_signature_string
		api_key = "api_key="+ Constants::MLB_API_KEY
		sig_string = "&sig="+ generateSignature
		return api_key+sig_string
	end

	def generateSignature
		timeFromEpoch = Time.now.to_i
		timeFromEpochString = timeFromEpoch.to_s
		puts "timestamp:"+ timeFromEpochString

		data = Constants::MLB_API_KEY + Constants::MLB_SECRET + timeFromEpochString
		sig = Digest::SHA256.hexdigest data

		sig
	end

	def make_api_request url
		response_back = nil
		api_request_time = Benchmark.realtime do
			request = APIRequest.new( :generic, DOMAIN )
			puts "url::"+ url.to_s
			response = request.for( :get, url, '')
			response_back = process_response response.body
		end
		response_back
	end

	def process_response(response)
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
				imageUrl = getImageUrl imageId
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

	def getImageUrl imageId
		event_url = "images/p128/"+imageId+"/?"
		sig = get_api_key_signature_string
		imageUrl = DOMAIN + ROUTE + event_url + sig
		puts "imageUrl:: "+ imageUrl
		return imageUrl
	end
end