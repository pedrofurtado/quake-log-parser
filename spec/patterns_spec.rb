RSpec.describe QuakeLogParser::Patterns do
  describe '#new_game' do
    it 'returns a Regexp' do
      expect(described_class.new_game).to be_a(Regexp)
    end
  end

  describe '#new_player' do
    it 'returns a Regexp' do
      expect(described_class.new_player).to be_a(Regexp)
    end
  end

  describe '#new_player_infos' do
    it 'returns a Regexp' do
      expect(described_class.new_player_infos).to be_a(Regexp)
    end
  end

  describe '#new_kill' do
    it 'returns a Regexp' do
      expect(described_class.new_kill).to be_a(Regexp)
    end
  end

  describe '#new_kill_infos' do
    it 'returns a Regexp' do
      expect(described_class.new_kill_infos).to be_a(Regexp)
    end
  end
end
