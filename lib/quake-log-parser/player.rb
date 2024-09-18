module QuakeLogParser
  class Player
    attr_accessor :name, :kills

    def initialize(name:)
      @name = name
      @kills = 0
    end

    def add_kill
      @kills += 1
    end

    def subtract_kill
      return if @kills.zero?

      @kills -= 1
    end
  end
end
