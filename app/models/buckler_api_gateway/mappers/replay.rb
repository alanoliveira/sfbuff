module BucklerApiGateway::Mappers
  class Replay < BaseMapper
    def replay_id
      dig("replay_id")
    end

    def replay_battle_type
      dig("replay_battle_type")
    end

    def uploaded_at
      dig("uploaded_at").try { Time.zone.at(it) }
    end

    def player1_info
      player_info(1)
    end

    def player2_info
      player_info(2)
    end

    private

    def player_info(side)
      PlayerInfo.new(dig("player#{side}_info") || {})
    end
  end
end
