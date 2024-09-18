module QuakeLogParser
  class Game
    attr_accessor :id, :total_kills, :players, :means_of_death, :kills

    def initialize(id:)
      @id = id
      @total_kills = 0
      @players = {}
      @means_of_death = {}
      @kills = []
    end

    def add_player(player)
      @players[player.name] = player
    end

    def add_total_kill
      @total_kills += 1
    end

    def add_means_of_death(mean)
      @means_of_death[mean] ||= 0
      @means_of_death[mean] += 1
    end

    def add_kill(kill)
      @kills << kill
    end
  end
end
