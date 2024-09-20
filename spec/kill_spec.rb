RSpec.describe QuakeLogParser::Kill do
  describe '#initialize' do
    it 'initializes a kill' do
      kill = described_class.new(killer: 'John', killed: 'Doe', mean_of_death: 'MEAN1')
      expect(kill.killer).to eq 'John'
      expect(kill.killed).to eq 'Doe'
      expect(kill.mean_of_death).to eq 'MEAN1'
    end
  end
end
