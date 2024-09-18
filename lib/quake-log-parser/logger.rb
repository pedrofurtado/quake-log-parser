require 'logger'

module QuakeLogParser
  class Logger
    def self.log(message)
      ::Logger.new($stdout).info(message)
    end
  end
end
