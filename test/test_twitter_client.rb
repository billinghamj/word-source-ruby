require 'minitest/autorun'

class TestTwitterClient < Minitest::Test
	def setup
		@tw = MiniTest::Mock.new
		@client = TwitterClient.new client: @tw
	end

	def test_search
		tweets = [
			Twitter::Tweet.new(id: '', text: 'testing this program'),
			Twitter::Tweet.new(id: '', text: 'testing is important'),
			Twitter::Tweet.new(id: '', text: 'testing is fun'),
			Twitter::Tweet.new(id: '', text: 'testing is foo bar')
		]

		@tw.expect :search, tweets, ['testing', result_type: 'recent']

		ws = @client.search 'testing'

		assert_equal 0, ws.count
		assert_empty ws.top_words
		assert_empty ws.top_characters
		assert_empty ws.top_vowels
		assert_empty ws.top_consonants
		assert_empty ws.top_5_words
		assert_empty ws.top_5_characters
		assert_empty ws.top_5_vowels
		assert_empty ws.top_5_consonants

		assert_equal true, ws.run
		assert_equal 13, ws.count
		assert_equal nil, ws.next_word
		assert_equal 13, ws.count
		assert_equal nil, ws.next_word
		assert_equal 13, ws.count

		assert_equal 'testing', ws.top_words[0]
		assert_equal 'is', ws.top_words[1]
	end
end
