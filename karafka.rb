$stdout.sync = true
$stderr.sync = true

ENV['KARAFKA_ENV'] ||= 'development'
Bundler.require(:default, ENV['KARAFKA_ENV'])

require_relative 'lib/quake-log-parser'

class KarafkaApp < Karafka::App
  setup do |config|
    config.kafka = {
      'bootstrap.servers': 'kafka:9092',
      'allow.auto.create.topics': false
    }
    config.client_id = 'quake_log_parser_client'
    config.initial_offset = 'earliest'
    config.consumer_persistence = ENV['KARAFKA_ENV'] != 'development'
  end

  Karafka.monitor.subscribe(Karafka::Instrumentation::LoggerListener.new)
  Karafka.producer.monitor.subscribe(
    WaterDrop::Instrumentation::LoggerListener.new(
      Karafka.logger,
      log_messages: false
    )
  )

  routes.draw do
    topic :quake_log_parser_topic do
      config(partitions: 3)
      consumer QuakeLogParser::KafkaTopicConsumer
      dead_letter_queue(
        topic: 'quake_log_parser_dead_letter_topic',
        max_retries: 0,
        independent: false
      )
    end
  end
end

Karafka::Web.setup do |config|
  config.ui.sessions.secret = 'dda09abf2cbd7d2e171dc44ed11877560a8bbc1ddbf54d2a58b0171634863513'
  config.tracking.interval = 5_000
end

Karafka::Web.enable!
