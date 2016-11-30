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
		puts response.code
		stat_status = nil
		case response.code
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
		else
			stat_status = {stat_error_code: response.code,
							stat_message: "Couldn't fetch data"}
			puts "something went wrong"
			return nil
		end
		content = {paragraphs: ["Data not found"]}
		{
			status: response.code,
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
end