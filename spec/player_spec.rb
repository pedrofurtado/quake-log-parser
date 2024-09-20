RSpec.describe QuakeLogParser::Player do
  let(:player) { described_class.new(name: 'Isgalamido') }

  describe '#initialize' do
    it 'creates a new player' do
      expect(player).to be_a(described_class)
      expect(player.name).to eq('Isgalamido')
      expect(player.kills).to eq(0)
    end
  end

  describe '#add_kill' do
    it 'adds a kill to the player' do
      player.add_kill
      expect(player.kills).to eq(1)
      player.add_kill
      expect(player.kills).to eq(2)
    end
  end

  describe '#subtract_kill' do
    it 'subtracts a kill from the player, but keep minimum on zero' do
      player.add_kill
      expect(player.kills).to eq(1)

      player.subtract_kill
      expect(player.kills).to eq(0)

      player.subtract_kill
      expect(player.kills).to eq(0)

      player.subtract_kill
      player.subtract_kill
      player.subtract_kill
      player.subtract_kill
      expect(player.kills).to eq(0)
    end
  end
end
