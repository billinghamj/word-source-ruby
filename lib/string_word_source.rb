require './stream_word_source'
require 'stringio'

class StringWordSource < StreamWordSource
	def initialize(string)
		super StringIO.new(string, 'r')
	end
end
