module QuakeLogParser
  class KafkaTopicReader
    def initialize(messages)
      @messages = messages
      @line_handler = QuakeLogParser::LineHandler.new
    end

    def read
      @messages.each do |message|
        if message.payload['lines']
          message.payload['lines'].each do |line|
            case line
            when QuakeLogParser::Patterns.new_game
              @line_handler.handle_new_game(line)
            when QuakeLogParser::Patterns.new_player
              @line_handler.handle_new_player(line)
            when QuakeLogParser::Patterns.new_kill
              @line_handler.handle_new_kill(line)
            end
          end
        end
      end
    end

    def results
      @line_handler.results
    end
  end
end
