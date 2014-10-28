require 'rake/testtask'
require 'simplecov'
require 'coveralls'

desc 'Tests the library'
task :test do
	Dir.glob('./test/test_*.rb').each { |file| require file }
end

namespace :test do
	desc 'Generates a coverage report'
	task :coverage do
		SimpleCov.formatter = Coveralls::SimpleCov::Formatter

		SimpleCov.start do
			add_filter '/test/'
		end

		Rake::Task['test'].execute
	end
end
