require './stream_word_source'

class FileWordSource < StreamWordSource
	def initialize(file)
		super File.open(file, 'r')
	end
end
