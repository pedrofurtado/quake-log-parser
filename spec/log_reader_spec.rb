RSpec.describe QuakeLogParser::LogReader do
  describe '#read' do
    it 'reads the log file and handle the lines' do
      new_game_count    = 0
      new_players_count = 0
      new_kills_count   = 0
      allow_any_instance_of(QuakeLogParser::LineHandler).to receive(:handle_new_game) { new_game_count += 1 }
      allow_any_instance_of(QuakeLogParser::LineHandler).to receive(:handle_new_player) { new_players_count += 1 }
      allow_any_instance_of(QuakeLogParser::LineHandler).to receive(:handle_new_kill) { new_kills_count += 1 }

      log_reader = described_class.new('spec/fixtures/sample.log')
      log_reader.read

      expect(new_game_count).to eq(1)
      expect(new_players_count).to eq(2)
      expect(new_kills_count).to eq(2)
    end

    it 'reads the empty log file and handle nothing' do
      new_game_count    = 0
      new_players_count = 0
      new_kills_count   = 0
      allow_any_instance_of(QuakeLogParser::LineHandler).to receive(:handle_new_game) { new_game_count += 1 }
      allow_any_instance_of(QuakeLogParser::LineHandler).to receive(:handle_new_player) { new_players_count += 1 }
      allow_any_instance_of(QuakeLogParser::LineHandler).to receive(:handle_new_kill) { new_kills_count += 1 }

      log_reader = described_class.new('spec/fixtures/empty.log')
      log_reader.read

      expect(new_game_count).to eq(0)
      expect(new_players_count).to eq(0)
      expect(new_kills_count).to eq(0)
    end
  end
end
