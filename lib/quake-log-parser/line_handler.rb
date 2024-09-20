require 'json'

module QuakeLogParser
  class LineHandler
    def initialize
      @games = []
    end

    def handle_new_game(_line)
      new_id = @games.size + 1
      @games << QuakeLogParser::Game.new(id: new_id)
      QuakeLogParser::Logger.log("Game ##{current_game.id}: New game")
    end

    def handle_new_player(line)
      player = Player.new(name: extract_player_name_from(line))
      current_game.add_player(player)
      QuakeLogParser::Logger.log("Game ##{current_game.id}: New player #{player.name}")
    end

    def handle_new_kill(line)
      killer, killed, means_of_death = extract_kill_infos_from(line)

      means_of_death.chomp!

      current_game.add_kill(QuakeLogParser::Kill.new(killer: killer, killed: killed, mean_of_death: means_of_death))

      previous_total_kills = current_game.total_kills
      current_game.add_total_kill

      previous_means_of_death = current_game.means_of_death[means_of_death] || 0
      current_game.add_means_of_death(means_of_death)

      base_log_message = "Game ##{current_game.id}: New kill. Game total_kills was from #{previous_total_kills} to #{current_game.total_kills} | Game total kills by means_of_death #{means_of_death} was from #{previous_means_of_death} to #{current_game.means_of_death[means_of_death]}"

      if killer == '<world>'
        player = current_game.players[killed]
        player_previous_kills = player.kills
        player.subtract_kill
        QuakeLogParser::Logger.log("#{base_log_message} | Player #{player.name} lost a kill because it was killed by <world> with #{means_of_death} | Player #{player.name} total kills was from #{player_previous_kills} to #{player.kills}")
      else
        player = current_game.players[killer]
        player_previous_kills = player.kills
        player.add_kill
        QuakeLogParser::Logger.log("#{base_log_message} | Player #{player.name} won a kill because killed #{killed} with #{means_of_death} - Player #{player.name} total kills was from #{player_previous_kills} to #{player.kills}")
      end
    end

    def results
      data = {}

      @games.each do |game|
        data["game_#{game.id}"] = {
          total_kills: game.total_kills,
          players: game.players.keys,
          kills: game.kills.map do |kill|
            {
              killer: kill.killer,
              killed: kill.killed,
              mean_of_death: kill.mean_of_death
            }
          end,
          kills_by_players: Hash[
            game.players
                .sort_by { |_player_name, player| player.kills }
                .reverse
                .collect { |_player_name, player| [player.name, player.kills] }
          ],
          kills_by_means: Hash[
            game.means_of_death
                .sort_by { |_mean, count| count }
                .reverse
                .collect { |mean, count| [mean, count] }
          ]
        }
      end

      data
    end

    private

    def current_game
      @games.last
    end

    def extract_player_name_from(line)
      line.match(QuakeLogParser::Patterns.new_player_infos)[1]
    end

    def extract_kill_infos_from(line)
      line.match(QuakeLogParser::Patterns.new_kill_infos)[1..3]
    end
  end
end
