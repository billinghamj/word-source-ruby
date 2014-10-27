require './stream_word_source'
require 'stringio'

class StringWordSource < StreamWordSource
	def initialize(string, options = {})
		io = StringIO.new string, 'r'
		super io, options
	end
end
