require 'base64'
require 'cgi'
require 'openssl'
require 'digest'

module Utils

    def Utils.get_api_key_signature_string(api_key, secret)
		apiKey = "api_key="+ api_key
		sig_string = "&sig="+ Utils.generateSignature(api_key, secret)
		return apiKey+sig_string
	end

    def Utils.generateSignature(api_key, secret)
    	timeFromEpoch = Time.now.to_i
		timeFromEpochString = timeFromEpoch.to_s
		puts "timestamp:"+ timeFromEpochString

		data = api_key + secret + timeFromEpochString
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
		case response.code
		when 200
			puts "all good"
			return nil
		when 403
			puts "forbidden"
			return {stat_error_code: 403,
					stat_status: "not authorized"}
		when 404
			puts "data not found"
			return {stat_error_code: 404,
					stat_status: "Data not found"}
		else
			puts "something went wrong"
			return nil
		end
	end
end