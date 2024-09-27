require 'karafka'

module QuakeLogParser
  class KafkaTopicConsumer < ::Karafka::BaseConsumer
    def consume
      ::Karafka.logger.info "[QuakeLogParser::KafkaTopicConsumer] Consuming #{messages.size} messages from TOPIC #{topic.name}"
      kafka_topic_reader = ::QuakeLogParser::KafkaTopicReader.new(messages)
      kafka_topic_reader.read
      ::Karafka.logger.info "[QuakeLogParser::KafkaTopicConsumer] Results: #{kafka_topic_reader.results}"
    end
  end
end
