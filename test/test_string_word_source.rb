require 'minitest/autorun'

class TestStringWordSource < Minitest::Test
	def test_initialization
		ws = StringWordSource.new 'test'

		assert_kind_of StringWordSource, ws
	end

	def test_before_run
		ws = StringWordSource.new 'lorem,ipsum'

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
		ws = StringWordSource.new 'ipsum,lorem,ipsum'

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
		ws = StringWordSource.new 'ipsum,lorem,ipsum'

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
		ws = StringWordSource.new 'ipsum,lorem,ipsum'

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

	def test_removed_callbacks
		ws = StringWordSource.new 'ipsum,lorem,ipsum'

		ipsum = 0
		lorem = 0

		ws.on_word 'ipsum' do
			ipsum += 1
		end

		ws.on_word 'lorem' do
			lorem += 1
		end

		ws.remove_word_callback 'ipsum'

		assert_equal true, ws.run

		assert_equal 0, ipsum
		assert_equal 1, lorem
	end

	def test_provided_use_case
   word_source = StringWordSource.new 'lorem,ipsum,ipsum'

   assert_equal 'lorem', word_source.next_word
   assert_equal 'ipsum', word_source.next_word
   assert_equal 'ipsum', word_source.next_word
   assert_equal ['ipsum', 'lorem'], word_source.top_5_words
   assert_array_sections [['m'], ['p', 's'], ['l', 'r']], word_source.top_5_consonants
   assert_equal 3, word_source.count

   word_source = StringWordSource.new 'lorem,ipsum,ipusum'

   assert_equal true, word_source.run
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
