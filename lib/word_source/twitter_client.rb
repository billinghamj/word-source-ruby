require 'twitter'
require 'word_source/twitter_tweets_word_source'

class TwitterClient
	def initialize(options)
		if options[:client]
			@client = options[:client]
		else
			@client = Twitter::REST::Client.new options
		end
	end

	def search(query)
		results = @client.search query, result_type: 'recent'

		TwitterTweetsWordSource.new results
	end
end
