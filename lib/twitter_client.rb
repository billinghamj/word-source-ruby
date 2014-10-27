require 'twitter'
require './twitter_tweets_word_source'

class TwitterClient
	def initialize(options)
		@client = Twitter::REST::Client.new options
	end

	def search(query)
		results = @client.search query, result_type: 'recent'

		TwitterTweetsWordSource.new results
	end
end
