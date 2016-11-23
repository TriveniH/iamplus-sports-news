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

   
end