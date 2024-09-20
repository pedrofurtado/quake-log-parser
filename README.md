# Quake Log Parser

[![Maintainability](https://api.codeclimate.com/v1/badges/8bbcb90abf1f392d7e68/maintainability)](https://codeclimate.com/github/pedrofurtado/quake-log-parser/maintainability)
![CI](https://github.com/pedrofurtado/quake-log-parser/actions/workflows/ci.yml/badge.svg)
[![codecov](https://codecov.io/gh/pedrofurtado/quake-log-parser/graph/badge.svg?token=DUC0CORI0N)](https://codecov.io/gh/pedrofurtado/quake-log-parser)
[![Gem Version](https://badge.fury.io/rb/quake-log-parser.svg)](https://badge.fury.io/rb/quake-log-parser)

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

## Usage

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
docker run --rm -v $(pwd):/app/ -it quake-log-parser_specs ruby real_example_to_run.rb
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pedrofurtado/quake-log-parser. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/pedrofurtado/quake-log-parser/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the quake-log-parser project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/pedrofurtado/quake-log-parser/blob/master/CODE_OF_CONDUCT.md).
