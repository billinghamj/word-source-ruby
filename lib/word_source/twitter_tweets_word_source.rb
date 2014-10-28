require 'word_source/stream_word_source'
require 'stringio'

class TwitterTweetsWordSource < StreamWordSource
	def initialize(tweets, options = {})
		io = StringIO.new

		tweets.each do |tweet|
			text = tweet.text.gsub /\s+/, ','
			io.write ','
			io.write text
		end

		io.rewind
		io.seek 1 # skip past leading comma

		super io, options
	end
end
