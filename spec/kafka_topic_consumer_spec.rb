RSpec.describe QuakeLogParser::KafkaTopicConsumer do
  subject(:consumer) { karafka.consumer_for('quake_log_parser_topic') }

  before do
    karafka.produce({ 'lines' => [] }.to_json)
    allow(Karafka.logger).to receive(:info)
  end

  it 'expects to consume the messages' do
    expect(Karafka.logger).to receive(:info).with("[QuakeLogParser::KafkaTopicConsumer] Consuming 1 messages from TOPIC quake_log_parser_topic")
    expect(Karafka.logger).to receive(:info).with("[QuakeLogParser::KafkaTopicConsumer] Results: {}")
    consumer.consume
  end
end
