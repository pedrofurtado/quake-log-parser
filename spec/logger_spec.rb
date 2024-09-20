require 'ostruct'
require 'logger'

RSpec.describe QuakeLogParser::Logger do
  describe '#log' do
    it 'logs a message' do
      logs_count = 0
      allow_any_instance_of(Logger).to receive(:info) { logs_count += 1 }
      described_class.log('This is a message')
      expect(logs_count).to eq(1)
    end
  end

  describe '#logger=' do
    it 'sets the logger' do
      expect(described_class.logger).to be_a(Logger)

      custom_fake_logger = OpenStruct.new
      described_class.logger = custom_fake_logger

      expect(described_class.logger).to eq(custom_fake_logger)
    end
  end
end
