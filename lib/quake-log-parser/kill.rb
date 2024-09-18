module QuakeLogParser
  class Kill
    attr_accessor :killer, :killed, :mean_of_death

    def initialize(killer:, killed:, mean_of_death:)
      @killer = killer
      @killed = killed
      @mean_of_death = mean_of_death
    end
  end
end
