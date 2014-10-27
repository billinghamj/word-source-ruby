require './stream_word_source'

class FileWordSource < StreamWordSource
	def initialize(file, options = {})
		io = File.open file, 'r'
		super io, options
	end
end
