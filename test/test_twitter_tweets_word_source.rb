require 'minitest/autorun'
require 'twitter'

class TestTwitterTweetsWordSource < Minitest::Test
	def setup
		tweets = [
			Twitter::Tweet.new(id: '', text: 'lorem ipsum dolor'),
			Twitter::Tweet.new(id: '', text: 'testing this program'),
			Twitter::Tweet.new(id: '', text: 'testing is important'),
			Twitter::Tweet.new(id: '', text: 'testing is fun'),
			Twitter::Tweet.new(id: '', text: 'testing is foo bar'),
			Twitter::Tweet.new(id: '', text: 'dolor ipsum'),
			Twitter::Tweet.new(id: '', text: 'lorem ipsum')
		]

		@word_source = TwitterTweetsWordSource.new tweets
	end

	def test_initialization
		assert_kind_of TwitterTweetsWordSource, @word_source
	end

	def test_before_run
		assert_equal 0, @word_source.count
		assert_empty @word_source.top_words
		assert_empty @word_source.top_characters
		assert_empty @word_source.top_vowels
		assert_empty @word_source.top_consonants
		assert_empty @word_source.top_5_words
		assert_empty @word_source.top_5_characters
		assert_empty @word_source.top_5_vowels
		assert_empty @word_source.top_5_consonants
	end

	def test_run
		assert_equal 0, @word_source.count
		assert_equal true, @word_source.run
		assert_equal 20, @word_source.count
		assert_equal nil, @word_source.next_word
		assert_equal 20, @word_source.count
		assert_equal nil, @word_source.next_word
		assert_equal 20, @word_source.count

		assert_array_sections [['testing'], ['ipsum', 'is'], ['dolor', 'lorem']], @word_source.top_5_words
	end

	def test_callbacks
		ipsum = 0
		lorem = 0

		@word_source.on_word 'ipsum' do
			ipsum += 1
		end

		@word_source.on_word 'lorem' do
			lorem += 1
		end

		assert_equal true, @word_source.run

		assert_equal 3, ipsum
		assert_equal 2, lorem
	end

	def test_removed_callbacks
		ipsum = 0
		lorem = 0

		@word_source.on_word 'ipsum' do
			ipsum += 1
		end

		@word_source.on_word 'lorem' do
			lorem += 1
		end

		@word_source.remove_word_callback 'ipsum'

		assert_equal true, @word_source.run

		assert_equal 0, ipsum
		assert_equal 2, lorem
	end

	def assert_array_sections(sections, arr)
		i = 0

		sections.each do |expected|
			section = arr[i...expected.length + i]

			expected.each { |e| assert_includes section, e }

			i += expected.length
		end
	end
end
