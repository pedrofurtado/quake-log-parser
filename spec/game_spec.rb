RSpec.describe QuakeLogParser::Game do
  describe '#initialize' do
    it 'creates a new game' do
      game = described_class.new(id: 1)
      expect(game.id).to eq(1)
      expect(game.total_kills).to eq(0)
      expect(game.players).to eq({})
      expect(game.means_of_death).to eq({})
      expect(game.kills).to eq([])
    end
  end

  describe '#add_player' do
    it 'adds a player' do
      game = described_class.new(id: 1)
      player_name = 'John'
      player = QuakeLogParser::Player.new(name: player_name)

      game.add_player(player)

      expect(game.players.keys.size).to eq 1
      expect(game.players.keys.first).to eq player_name
      expect(game.players[player_name]).to eq player
    end
  end

  describe '#add_total_kill' do
    it 'adds one unit to total kill' do
      game = described_class.new(id: 1)
      expect(game.total_kills).to eq 0

      game.add_total_kill
      expect(game.total_kills).to eq 1

      game.add_total_kill
      expect(game.total_kills).to eq 2

      game.add_total_kill
      expect(game.total_kills).to eq 3
    end
  end

  describe '#add_means_of_death' do
    it 'adds means of death' do
      game = described_class.new(id: 1)
      expect(game.means_of_death).to eq({})

      mean = 'MEAN1'
      game.add_means_of_death(mean)
      expect(game.means_of_death.keys.size).to eq 1
      expect(game.means_of_death.keys.first).to eq mean
      expect(game.means_of_death[mean]).to eq 1

      game.add_means_of_death(mean)
      expect(game.means_of_death.keys.size).to eq 1
      expect(game.means_of_death.keys.first).to eq mean
      expect(game.means_of_death[mean]).to eq 2

      game.add_means_of_death(mean)
      expect(game.means_of_death.keys.size).to eq 1
      expect(game.means_of_death.keys.first).to eq mean
      expect(game.means_of_death[mean]).to eq 3

      second_mean = 'MEAN2'
      game.add_means_of_death(second_mean)
      expect(game.means_of_death.keys.size).to eq 2
      expect(game.means_of_death[second_mean]).to eq 1
    end
  end

  describe '#add_kill' do
    it 'adds a kill' do
      game = described_class.new(id: 1)
      expect(game.kills).to eq([])

      kill = QuakeLogParser::Kill.new(killer: 'John', killed: 'Mary', mean_of_death: 'MEAN1')
      game.add_kill(kill)
      expect(game.kills.size).to eq 1
      expect(game.kills.first).to eq kill

      second_kill = QuakeLogParser::Kill.new(killer: 'Steve', killed: 'Jane', mean_of_death: 'MEAN2')
      game.add_kill(second_kill)
      expect(game.kills.size).to eq 2
      expect(game.kills.last).to eq second_kill
    end
  end
end
