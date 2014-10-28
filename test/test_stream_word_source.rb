require 'minitest/autorun'
require './lib/stream_word_source'

class TestStreamWordSource < Minitest::Test
	def test_initialization
		ws = StreamWordSource.new nil

		assert_kind_of StreamWordSource, ws
	end

	def test_before_run
		io = StringIO.new 'lorem,ipsum'
		ws = StreamWordSource.new io

		assert_equal 0, ws.count
		assert_empty ws.top_words
		assert_empty ws.top_characters
		assert_empty ws.top_vowels
		assert_empty ws.top_consonants
		assert_empty ws.top_5_words
		assert_empty ws.top_5_characters
		assert_empty ws.top_5_vowels
		assert_empty ws.top_5_consonants
	end

	def test_per_word_run
		io = StringIO.new 'ipsum,lorem,ipsum'
		ws = StreamWordSource.new io

		assert_equal 0, ws.count
		assert_equal 'ipsum', ws.next_word
		assert_equal 1, ws.count
		assert_equal 'lorem', ws.next_word
		assert_equal 2, ws.count
		assert_equal 'ipsum', ws.next_word
		assert_equal 3, ws.count
		assert_equal nil, ws.next_word
		assert_equal 3, ws.count
		assert_equal nil, ws.next_word
		assert_equal 3, ws.count

		assert_equal 'ipsum', ws.top_words[0]
		assert_equal 'lorem', ws.top_words[1]
	end

	def test_run
		io = StringIO.new 'ipsum,lorem,ipsum'
		ws = StreamWordSource.new io

		assert_equal 0, ws.count
		assert_equal true, ws.run
		assert_equal 3, ws.count
		assert_equal nil, ws.next_word
		assert_equal 3, ws.count
		assert_equal nil, ws.next_word
		assert_equal 3, ws.count

		assert_equal 'ipsum', ws.top_words[0]
		assert_equal 'lorem', ws.top_words[1]
	end

	def test_callbacks
		io = StringIO.new 'ipsum,lorem,ipsum'
		ws = StreamWordSource.new io

		ipsum = 0
		lorem = 0

		ws.on_word 'ipsum' do
			ipsum += 1
		end

		ws.on_word 'lorem' do
			lorem += 1
		end

		assert_equal true, ws.run

		assert_equal 2, ipsum
		assert_equal 1, lorem
	end
end
