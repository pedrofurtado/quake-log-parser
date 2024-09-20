require_relative 'lib/quake-log-parser'

parser = QuakeLogParser::LogReader.new('/app/spec/fixtures/quake.log')
parser.read
sleep 2
puts JSON.pretty_generate(parser.results)
