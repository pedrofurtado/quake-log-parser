RSpec.describe QuakeLogParser::LineHandler do
  describe '#initialize' do
    it 'has empty game' do
      line_handler = described_class.new
      expect(line_handler.results).to eq({})
    end
  end

  describe '#handle_new_game' do
    it 'handles the line contains the start of game' do
      line_handler = described_class.new
      init_game_line = '0:00 InitGame: \sv_floodProtect\1\sv_maxPing\0\sv_minPing\0\sv_maxRate\10000\sv_minRate\0\sv_hostname\Code Miner Server\g_gametype\0\sv_privateClients\2\sv_maxclients\16\sv_allowDownload\0\dmflags\0\fraglimit\20\timelimit\15\g_maxGameClients\0\capturelimit\8\version\ioq3 1.36 linux-x86_64 Apr 12 2009\protocol\68\mapname\q3dm17\gamename\baseq3\g_needpass\0'

      line_handler.handle_new_game(init_game_line)
      game_1_data = { 'game_1' => { total_kills: 0, players: [], kills: [], kills_by_players: {}, kills_by_means: {} } }
      expect(line_handler.results).to eq(game_1_data)

      line_handler.handle_new_game(init_game_line)
      game_2_data = game_1_data.merge({ 'game_2' => { total_kills: 0, players: [], kills: [], kills_by_players: {}, kills_by_means: {} } })
      expect(line_handler.results).to eq(game_2_data)

      line_handler.handle_new_game(init_game_line)
      game_3_data = game_2_data.merge({ 'game_3' => { total_kills: 0, players: [], kills: [], kills_by_players: {}, kills_by_means: {} } })
      expect(line_handler.results).to eq(game_3_data)
    end
  end

  describe '#handle_new_player' do
    it 'handles the line contains the new player of game' do
      line_handler = described_class.new
      init_game_line = '0:00 InitGame: \sv_floodProtect\1\sv_maxPing\0\sv_minPing\0\sv_maxRate\10000\sv_minRate\0\sv_hostname\Code Miner Server\g_gametype\0\sv_privateClients\2\sv_maxclients\16\sv_allowDownload\0\dmflags\0\fraglimit\20\timelimit\15\g_maxGameClients\0\capturelimit\8\version\ioq3 1.36 linux-x86_64 Apr 12 2009\protocol\68\mapname\q3dm17\gamename\baseq3\g_needpass\0'
      new_player_line = '0:25 ClientUserinfoChanged: 2 n\Dono da Bola\t\0\model\sarge/krusade\hmodel\sarge/krusade\g_redteam\\g_blueteam\\c1\5\c2\5\hc\95\w\0\l\0\tt\0\tl\0'
      new_player2_line = '0:25 ClientUserinfoChanged: 2 n\Mocinha\t\0\model\sarge/krusade\hmodel\sarge/krusade\g_redteam\\g_blueteam\\c1\5\c2\5\hc\95\w\0\l\0\tt\0\tl\0'

      line_handler.handle_new_game(init_game_line)
      line_handler.handle_new_player(new_player_line)
      expect(line_handler.results).to eq({ 'game_1' => { total_kills: 0, players: ['Dono da Bola'], kills: [], kills_by_players: {'Dono da Bola' => 0}, kills_by_means: {} } })

      line_handler.handle_new_player(new_player2_line)
      expect(line_handler.results).to eq({ 'game_1' => { total_kills: 0, players: ['Dono da Bola', 'Mocinha'], kills: [], kills_by_players: {'Dono da Bola' => 0, 'Mocinha' => 0}, kills_by_means: {} } })
    end
  end

  describe '#handle_new_kill' do
    it 'handles the line contains the new kill in game' do
      line_handler = described_class.new
      init_game_line = '0:00 InitGame: \sv_floodProtect\1\sv_maxPing\0\sv_minPing\0\sv_maxRate\10000\sv_minRate\0\sv_hostname\Code Miner Server\g_gametype\0\sv_privateClients\2\sv_maxclients\16\sv_allowDownload\0\dmflags\0\fraglimit\20\timelimit\15\g_maxGameClients\0\capturelimit\8\version\ioq3 1.36 linux-x86_64 Apr 12 2009\protocol\68\mapname\q3dm17\gamename\baseq3\g_needpass\0'
      new_player_line = '0:25 ClientUserinfoChanged: 2 n\Dono da Bola\t\0\model\sarge/krusade\hmodel\sarge/krusade\g_redteam\\g_blueteam\\c1\5\c2\5\hc\95\w\0\l\0\tt\0\tl\0'
      new_player2_line = '0:25 ClientUserinfoChanged: 2 n\Mocinha\t\0\model\sarge/krusade\hmodel\sarge/krusade\g_redteam\\g_blueteam\\c1\5\c2\5\hc\95\w\0\l\0\tt\0\tl\0'
      new_kill_line = '1:02 Kill: 2 3 7: Dono da Bola killed Mocinha by MOD_ROCKET_SPLASH'
      new_kill2_line = '1:02 Kill: 2 3 7: Mocinha killed Dono da Bola by MOD_ROCKET'
      world_kill_line = '15:27 Kill: 1022 5 22: <world> killed Mocinha by MOD_TRIGGER_HURT'

      line_handler.handle_new_game(init_game_line)
      line_handler.handle_new_player(new_player_line)
      line_handler.handle_new_player(new_player2_line)

      line_handler.handle_new_kill(new_kill_line)
      expect(line_handler.results).to eq({ 'game_1' => { total_kills: 1, players: ['Dono da Bola', 'Mocinha'], kills: [{ killer: 'Dono da Bola', killed: 'Mocinha', mean_of_death: 'MOD_ROCKET_SPLASH' }], kills_by_players: { 'Dono da Bola' => 1, 'Mocinha' => 0 }, kills_by_means: { 'MOD_ROCKET_SPLASH' => 1 } } })

      line_handler.handle_new_kill(new_kill2_line)
      expect(line_handler.results).to eq({ 'game_1' => { total_kills: 2, players: ['Dono da Bola', 'Mocinha'], kills: [{ killer: 'Dono da Bola', killed: 'Mocinha', mean_of_death: 'MOD_ROCKET_SPLASH' }, { killer: 'Mocinha', killed: 'Dono da Bola', mean_of_death: 'MOD_ROCKET' }], kills_by_players: { 'Dono da Bola' => 1, 'Mocinha' => 1 }, kills_by_means: { 'MOD_ROCKET_SPLASH' => 1, 'MOD_ROCKET' => 1 } } })

      line_handler.handle_new_kill(world_kill_line)
      expect(line_handler.results).to eq({ 'game_1' => { total_kills: 3, players: ['Dono da Bola', 'Mocinha'], kills: [{ killer: 'Dono da Bola', killed: 'Mocinha', mean_of_death: 'MOD_ROCKET_SPLASH' }, { killer: 'Mocinha', killed: 'Dono da Bola', mean_of_death: 'MOD_ROCKET' }, { killer: '<world>', killed: 'Mocinha', mean_of_death: 'MOD_TRIGGER_HURT' }], kills_by_players: { 'Dono da Bola' => 1, 'Mocinha' => 0 }, kills_by_means: { 'MOD_ROCKET_SPLASH' => 1, 'MOD_ROCKET' => 1, 'MOD_TRIGGER_HURT' => 1 } } })
    end
  end
end
