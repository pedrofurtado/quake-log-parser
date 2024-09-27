# Quake Log Parser

[![Maintainability](https://api.codeclimate.com/v1/badges/8bbcb90abf1f392d7e68/maintainability)](https://codeclimate.com/github/pedrofurtado/quake-log-parser/maintainability)
![CI](https://github.com/pedrofurtado/quake-log-parser/actions/workflows/ci.yml/badge.svg)
[![codecov](https://codecov.io/gh/pedrofurtado/quake-log-parser/graph/badge.svg?token=DUC0CORI0N)](https://codecov.io/gh/pedrofurtado/quake-log-parser)

Ruby gem for quake log parsing.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'quake-log-parser'
```

And then execute:

    bundle install

Or install it yourself as:

    gem install quake-log-parser

## Usage - Log reader

```ruby
require 'quake-log-parser'

if defined?(Rails)
  QuakeLogParser::Logger.logger = Rails.logger
else
  QuakeLogParser::Logger.logger = Logger.new($stdout)
end

parser = QuakeLogParser::LogReader.new('/path/to/your/quake.log')
parser.read

puts JSON.pretty_generate(parser.results)
```

## Usage - Emulated Kafka topic reader

```ruby
=begin
All kafka topic messages must have this structure:

{
  "lines": [
    "content of line 01 with slashs escaped",
    "content of line 02 with slashs escaped",
    "content of line 03 with slashs escaped",
    "..."
  ]
}

Example of message (with slashs escaped):

{
  "lines": [
    "0:00 InitGame: \\sv_floodProtect\\1\\sv_maxPing\\0\\sv_minPing\\0\\sv_maxRate\\10000\\sv_minRate\\0\\sv_hostname\\Code Miner Server\\g_gametype\\0\\sv_privateClients\\2\\sv_maxclients\\16\\sv_allowDownload\\0\\dmflags\\0\fraglimit\\20\\timelimit\\15\\g_maxGameClients\\0\\capturelimit\\8\\version\\ioq3 1.36 linux-x86_64 Apr 12 2009\\protocol\\68\\mapname\\q3dm17\\gamename\baseq3\\g_needpass\\0",
    "20:34 ClientUserinfoChanged: 2 n\\Isgalamido\\t\\0\\model\\xian/default\\hmodel\\xian/default\\g_redteam\\g_blueteam\\c1\\4\\c2\\5\\hc\\100\\w\\0\\l\\0\\tt\\0\\tl\\0",
    "20:54 Kill: 1022 2 22: <world> killed Isgalamido by MOD_TRIGGER_HURT",
    "21:51 ClientUserinfoChanged: 3 n\\Dono da Bola\\t\\0\\model\\sarge/krusade\\hmodel\\sarge/krusade\\g_redteam\\g_blueteam\\c1\\5\\c2\\5\\hc\\95\\w\\0\\l\\0\\tt\\0\\tl\\0",
    "22:06 Kill: 2 3 7: Isgalamido killed Dono da Bola by MOD_ROCKET_SPLASH"
  ]
}
=end

require 'quake-log-parser'
require 'ostruct'

if defined?(Rails)
  QuakeLogParser::Logger.logger = Rails.logger
else
  QuakeLogParser::Logger.logger = Logger.new($stdout)
end

quake_log_lines = [
  'content of line 01 with slashs escaped',
  'content of line 02 with slashs escaped',
  'content of line 03 with slashs escaped',
  '...'
]

emulated_messages_from_kafka = [
  OpenStruct.new(payload: { 'lines' => quake_log_lines })
]

parser = QuakeLogParser::KafkaTopicReader.new(emulated_messages_from_kafka)
parser.read

puts JSON.pretty_generate(parser.results)
```

## Usage - Kafka producer inside Karafka console

```ruby
# Enter the Karafka console with the command below:
# docker-compose up --build -d (Wait Kafka components and Karafka consumer to be ready)
# docker container exec -it quake-log-parser_kafka_consumer_1 bundle exec karafka console

# Then, open a second terminal to see logs of Karafka consumer with the command below:
# docker container logs -f quake-log-parser_kafka_consumer_1 | grep -i 'quake'

# Then, run the commands below to produce a message to a Kafka topic:

topic_name = 'quake_log_parser_topic'
key = SecureRandom.uuid
payload = {
  "lines" => [
    "0:00 InitGame: \\sv_floodProtect\\1\\sv_maxPing\\0\\sv_minPing\\0\\sv_maxRate\\10000\\sv_minRate\\0\\sv_hostname\\Code Miner Server\\g_gametype\\0\\sv_privateClients\\2\\sv_maxclients\\16\\sv_allowDownload\\0\\dmflags\\0\fraglimit\\20\\timelimit\\15\\g_maxGameClients\\0\\capturelimit\\8\\version\\ioq3 1.36 linux-x86_64 Apr 12 2009\\protocol\\68\\mapname\\q3dm17\\gamename\baseq3\\g_needpass\\0",
    "20:34 ClientUserinfoChanged: 2 n\\Isgalamido\\t\\0\\model\\xian/default\\hmodel\\xian/default\\g_redteam\\g_blueteam\\c1\\4\\c2\\5\\hc\\100\\w\\0\\l\\0\\tt\\0\\tl\\0",
    "20:54 Kill: 1022 2 22: <world> killed Isgalamido by MOD_TRIGGER_HURT",
    "21:51 ClientUserinfoChanged: 3 n\\Dono da Bola\\t\\0\\model\\sarge/krusade\\hmodel\\sarge/krusade\\g_redteam\\g_blueteam\\c1\\5\\c2\\5\\hc\\95\\w\\0\\l\\0\\tt\\0\\tl\\0",
    "22:06 Kill: 2 3 7: Isgalamido killed Dono da Bola by MOD_ROCKET_SPLASH"
  ]
}
producer = Karafka.producer.produce_sync(topic: topic_name, payload: payload.to_json, key: key)
Karafka.logger.info("[QuakeLogParser::KafkaTopicProducer] send_sync topic=#{topic_name} key=#{key} offset=#{producer.offset} partition=#{producer.partition} payload=#{payload}")
```

## Execute tests/specs

To execute gem tests locally, use Docker with the commands below:

```bash
git clone https://github.com/pedrofurtado/quake-log-parser
cd quake-log-parser/
docker build -t quake-log-parser_specs .

# Then, run this command how many times you want,
# after editing local files, and so on, to get
# feedback from test suite of gem.
docker run --rm -v $(pwd):/app/ -it quake-log-parser_specs

# Or, if you want to run a example of usage of gem,
# you can run the command below.
docker run --rm -v $(pwd):/app/ -it quake-log-parser_specs bundle exec ruby real_example_to_run.rb
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pedrofurtado/quake-log-parser. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/pedrofurtado/quake-log-parser/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the quake-log-parser project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/pedrofurtado/quake-log-parser/blob/master/CODE_OF_CONDUCT.md).
