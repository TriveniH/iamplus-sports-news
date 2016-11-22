class TwitterSkill
	def getTwitterClient
		client = Twitter::REST::Client.new do |config|
  			config.consumer_key        = "UOhPjUPYFZJqreG8X3zm2d0DM"
  			config.consumer_secret     = "gFor40PjEhpM0MqwDZNhv2fcAtaUSHimtLxu1BwWbhG4PifaFX"
  			config.access_token        = "795879557479829504-bbPvAMyO9Fafj4wkX4aPF5S6OiIpHY7"
  			config.access_token_secret = "ZsTRkdCiuTbSqBD5o1tb8oQws6mRkUmpgaz7sSsauq8pH"
		end
	end

	def do_tweet tweet_text
		client = getTwitterClient
		tweet = client.update(tweet_text)
	end

	def do_tweet_with_media(tweet_text, path_to_media)
		client = getTwitterClient
		mediaId = client.upload(File.new(path_to_media), {})
		tweet = client.update(tweet_text, :media_ids => mediaId)
		#tweet = client.update_with_media(tweet_text, File.new('golden_sunshine_at_yellow_river_state_forest_iowa.jpeg'), {})
		puts "tweet:: "+ tweet.text
	end

	def do_tweet_with_video(tweet_text, path_to_media)
		client = getTwitterClient
		filesize = File.open(path_to_media).size
		
		init_request = Twitter::REST::Request.new(client, :post, "https://upload.twitter.com/1.1/media/upload.json?command=INIT&total_bytes=#{filesize}&media_type=video/mp4").perform
		media_id = init_request[:media_id]

		Twitter::REST::Request.new(client, :post, "https://upload.twitter.com/1.1/media/upload.json?command=APPEND&media_id=#{media_id}&media=#{path_to_media}&segment_index=0").perform
		Twitter::REST::Request.new(client, :post, "https://upload.twitter.com/1.1/media/upload.json?command=FINALIZE&media_id=#{media_id}").perform
		
		tweet = client.update(tweet_text, :media_ids => media_id)

	end

	def do_retweet tweet_text
		client = getTwitterClient
		client.search(tweet_text, result_type: "recent").take(1).each do |tweet|
			puts "its coming inside:: "+ tweet.to_s
			puts tweet.text
			client.retweet tweet
		end
	end

	def do_reply(tweet_text, reply_text)
		client = getTwitterClient

		client.search(tweet_text, result_type: "recent").take(1).each do |tweet|
			puts "its coming inside:: "+ tweet.to_s
			puts tweet.text
			client.update(reply_text, {in_reply_to_status: tweet})
		end
	end

	def do_read_tweets
		client = getTwitterClient
		tweetsArray = client.home_timeline({count: 200})
		tweetsArray.each do | timeLineTweet |
			puts "TimeLine: "+timeLineTweet.text+"\n"
		end
	end

	def do_send_direct_messages screenName
		client = getTwitterClient
		client.create_direct_message(screenName, "sending a direct message.. testing", {})
	end

	def do_delete_direct_messages
		#deletes direct received messages.
		client = getTwitterClient
		messages = client.direct_messages({count: 10})
		puts "messages::  "+messages.to_s
		messages.each do |message|
			puts "coming inside"
			client.destroy_direct_message([message.id])
		end
	end	
end