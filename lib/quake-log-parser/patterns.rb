module QuakeLogParser
  class Patterns
    def self.new_game
      /InitGame:/
    end

    def self.new_player
      /ClientUserinfoChanged:/
    end

    def self.new_player_infos
      /ClientUserinfoChanged: [0-9]+ n\\(.*?)\\t/
    end

    def self.new_kill
      /Kill:/
    end

    def self.new_kill_infos
      /Kill: [0-9]+ [0-9]+ [0-9]+: (.*?) killed (.*?) by (.*?)$/
    end
  end
end
