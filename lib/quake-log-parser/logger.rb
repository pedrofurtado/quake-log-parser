require 'logger'

module QuakeLogParser
  class Logger
    @@logger = ::Logger.new($stdout)

    def self.logger
      @@logger
    end

    def self.logger=(logger)
      @@logger = logger
    end

    def self.log(message)
      @@logger.info(message)
    end
  end
end
