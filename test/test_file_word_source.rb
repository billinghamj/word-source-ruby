require 'minitest/autorun'

class TestFileWordSource < Minitest::Test
	def setup
		@word_source = FileWordSource.new "#{File.dirname(__FILE__)}/lorem_ipsum.txt"
	end

	def test_initialization
		assert_kind_of FileWordSource, @word_source
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
		assert_equal 4946, @word_source.count
		assert_equal nil, @word_source.next_word
		assert_equal 4946, @word_source.count
		assert_equal nil, @word_source.next_word
		assert_equal 4946, @word_source.count

		assert_equal ['sed', 'in', 'ut', 'vel', 'vitae'], @word_source.top_5_words
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

		assert_equal 48, ipsum
		assert_equal 23, lorem
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
		assert_equal 23, lorem
	end
end
