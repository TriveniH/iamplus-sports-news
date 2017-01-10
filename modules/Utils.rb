require 'digest'
require 'securerandom'

module Utils

    def Utils.get_api_key_signature_string(api_key, secret, eventId)
		apiKey = "api_key="+ api_key
		sig_string = "&sig="+ Utils.generateSignature(api_key, secret, eventId)
		return apiKey+sig_string
	end

    def Utils.generateSignature(api_key, secret, eventId)
    	if eventId == nil
    		eventId=""
    	end
    	if @mutex == nil
    		@mutex = Mutex.new
    	end
    	@mutex.synchronize {
    		# access shared resource
    		timeFromEpoch = Time.now.to_i
    		timeFromEpoch = timeFromEpoch
			@timeFromEpochString = timeFromEpoch.to_s
			puts "timestamp:"+ @timeFromEpochString + " for eventId::"+ eventId.to_s
  		}

		data = api_key + secret + @timeFromEpochString
		sig = Digest::SHA256.hexdigest data

		return sig
    end

	def Utils.is_blank? str
    	str.to_s.strip == ''
  	end

  	def Utils.is_present? str
    	! is_blank?( str )
  	end
   
   	def Utils.check_response_status response
		generate_error_response response.code
	end

	def Utils.generate_error_response errorCode
		stat_status = nil
		case errorCode
		when 200
			puts "all good"
			return nil
		when 403
			puts "forbidden"
			stat_status = {stat_error_code: 403,
					stat_message: "not authorized"}
		when 404
			puts "data not found"
			stat_status = {stat_error_code: 404,
							stat_message: "Data not found"}
		when 500
			puts "internal server error"
			stat_status = {stat_error_code: 500,
							stat_message: "stat internal server error"}
		else
			stat_status = {stat_error_code: errorCode,
							stat_message: "Couldn't fetch data"}
			puts "something went wrong"
			return nil
		end
		content = {paragraphs: ["Data not found"]}
		{
			status: errorCode,
			stat_status: stat_status,
			timeTaken: nil,
			date: nil,
			dateType: nil,
			eventId: nil,
			imageUrl: nil,
			headline: nil,
			content: content
		}
	end

	def Utils.check_for_forbidden_error error_response
		puts error_response.to_s
		#parsedResponse = JSON.parse(error_response)
		status = error_response[:status]

		puts status.to_s
		if status == 403
			puts "forbidden"
			return true
		end
		return false
	end

	def Utils.save_headlines(response, leagueName)
		#puts response.to_s
		#response = JSON.parse(responseJson)
		headlines = response[:headlines]
		puts "headlines:"+ headlines.to_s
		if headlines == nil || headlines.length < 1
			return
		end

		dateTime = response[:date]
		dateType = response[:date_type]
		imageUrl = response[:image_url]
		teamId = response[:team_id]
		headlinesArray = []
		headlines.each do |headline|
			headlinesArray << headline[:headlineText]
		end
		puts "headlinesArray::"+ headlinesArray.to_s
		if headlinesArray == nil || headlinesArray.length <= 0
			return
		end
		DBHelperHeadLines._save_headlines(dateTime, dateType, imageUrl, headlinesArray, leagueName, teamId)
	end

	def Utils._fetch_recap_preview
		fetch_update_schedule
	end


end