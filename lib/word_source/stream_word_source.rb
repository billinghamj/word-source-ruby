class StreamWordSource
	DEFAULT_OPTIONS = {
		separator: ','
	}

	VOWELS = 'aeiou'.chars
	CONSONANTS = 'bcdfghjklmnpqrstvwxyz'.chars

	def initialize(stream, options = {})
		@stream = stream

		options = DEFAULT_OPTIONS.merge options
		@separator = options[:separator] # ivar because called often

		@word_count = 0
		@word_usage = Hash.new(0)
		@character_usage = Hash.new(0)
		@word_callbacks = {}
	end

	def next_word
		word = @stream.gets @separator

		return nil unless word

		# gets includes the separator
		word.chomp! @separator

		# clean up word for consistency
		word.strip!
		word.downcase!

		return nil unless word.length

		@word_count += 1
		@word_usage[word] += 1

		# no vowel/consonant sorting here - more efficient in bulk
		# consider map reduce here?
		word.each_char do |char|
			@character_usage[char.downcase] += 1
		end

		block = @word_callbacks[word]
		block.call if block

		word
	end

	def run
		loop do
			break unless next_word
		end

		@word_count > 0
	end

	def on_word(word, &block)
		word = word.strip.downcase
		@word_callbacks[word] = block
	end

	def remove_word_callback(word)
		word = word.strip.downcase
		@word_callbacks[word] = nil
	end

	def count
		@word_count
	end

	def top_words
		words = @word_usage.sort_by { |k, v| v }
		words = words.map { |k, v| k }
		words.reverse
	end

	def top_characters
		chars = @character_usage.sort_by { |k, v| v }
		chars = chars.map { |k, v| k }
		chars.reverse
	end

	def top_vowels
		chars = @character_usage.select { |v| VOWELS.include? v }
		chars = chars.sort_by { |k, v| v }
		chars = chars.map { |k, v| k }
		chars.reverse
	end

	def top_consonants
		chars = @character_usage.select { |v| CONSONANTS.include? v }
		chars = chars.sort_by { |k, v| v }
		chars = chars.map { |k, v| k }
		chars.reverse
	end

	def top_5_words
		top_words[0...5]
	end

	def top_5_characters
		top_characters[0...5]
	end

	def top_5_vowels
		top_vowels[0...5]
	end

	def top_5_consonants
		top_consonants[0...5]
	end
end
