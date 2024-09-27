require 'ostruct'

RSpec.describe QuakeLogParser::KafkaTopicReader do
  let(:emulated_messages_from_kafka) do
    [
      OpenStruct.new(payload: {
        'lines' => [
          '0:00 InitGame: \sv_floodProtect\1\sv_maxPing\0\sv_minPing\0\sv_maxRate\10000\sv_minRate\0\sv_hostname\Code Miner Server\g_gametype\0\sv_privateClients\2\sv_maxclients\16\sv_allowDownload\0\dmflags\0\fraglimit\20\timelimit\15\g_maxGameClients\0\capturelimit\8\version\ioq3 1.36 linux-x86_64 Apr 12 2009\protocol\68\mapname\q3dm17\gamename\baseq3\g_needpass\0',
          '20:34 ClientUserinfoChanged: 2 n\Isgalamido\t\0\model\xian/default\hmodel\xian/default\g_redteam\\g_blueteam\\c1\4\c2\5\hc\100\w\0\l\0\tt\0\tl\0',
          '20:54 Kill: 1022 2 22: <world> killed Isgalamido by MOD_TRIGGER_HURT',
          '21:51 ClientUserinfoChanged: 3 n\Dono da Bola\t\0\model\sarge/krusade\hmodel\sarge/krusade\g_redteam\\g_blueteam\\c1\5\c2\5\hc\95\w\0\l\0\tt\0\tl\0',
          '22:06 Kill: 2 3 7: Isgalamido killed Dono da Bola by MOD_ROCKET_SPLASH'
        ]
      })
    ]
  end

  let(:emulated_messages_from_kafka_with_empty_lines) do
    [
      OpenStruct.new(payload: { 'lines' => [] })
    ]
  end

  describe '#read' do
    it 'reads the topic messages and handle the lines' do
      new_game_count    = 0
      new_players_count = 0
      new_kills_count   = 0
      allow_any_instance_of(QuakeLogParser::LineHandler).to receive(:handle_new_game) { new_game_count += 1 }
      allow_any_instance_of(QuakeLogParser::LineHandler).to receive(:handle_new_player) { new_players_count += 1 }
      allow_any_instance_of(QuakeLogParser::LineHandler).to receive(:handle_new_kill) { new_kills_count += 1 }

      kafka_topic_reader = described_class.new(emulated_messages_from_kafka)
      kafka_topic_reader.read

      expect(new_game_count).to eq(1)
      expect(new_players_count).to eq(2)
      expect(new_kills_count).to eq(2)
    end

    it 'reads the topic messages with empty lines and handle nothing' do
      new_game_count    = 0
      new_players_count = 0
      new_kills_count   = 0
      allow_any_instance_of(QuakeLogParser::LineHandler).to receive(:handle_new_game) { new_game_count += 1 }
      allow_any_instance_of(QuakeLogParser::LineHandler).to receive(:handle_new_player) { new_players_count += 1 }
      allow_any_instance_of(QuakeLogParser::LineHandler).to receive(:handle_new_kill) { new_kills_count += 1 }

      kafka_topic_reader = described_class.new(emulated_messages_from_kafka_with_empty_lines)
      kafka_topic_reader.read

      expect(new_game_count).to eq(0)
      expect(new_players_count).to eq(0)
      expect(new_kills_count).to eq(0)
    end
  end
end
