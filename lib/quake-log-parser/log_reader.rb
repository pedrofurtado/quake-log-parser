module QuakeLogParser
  class LogReader
    def initialize(file_path)
      @file_path = file_path
      @line_handler = QuakeLogParser::LineHandler.new
    end

    def read
      File.open(@file_path, 'r') do |file|
        file.each_line do |line|
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

    def results
      @line_handler.results
    end
  end
end
