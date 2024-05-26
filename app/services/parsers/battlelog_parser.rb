# frozen_string_literal: true

module Parsers
  class BattlelogParser
    def self.parse(raw_data)
      new(raw_data).parse
    end

    def initialize(raw_data)
      @raw_data = raw_data
    end

    def parse
      battle = parse_battle
      battle.p1 = parse_challenger_data(1)
      battle.p2 = parse_challenger_data(2)
      battle.winner_side = eval_winner
      battle.raw_battle = RawBattle.new(data: @raw_data)
      battle
    end

    private

    def eval_winner
      p1_rounds = @raw_data.dig('player1_info', 'round_results')
      p2_rounds = @raw_data.dig('player2_info', 'round_results')
      WinnerEvaluator.evaluate_winner(p1_rounds, p2_rounds)
    end

    def parse_battle
      Battle.new(
        replay_id: @raw_data.fetch('replay_id'),
        battle_type: @raw_data.fetch('replay_battle_type'),
        battle_subtype: @raw_data.fetch('replay_battle_sub_type'),
        played_at: Time.at(@raw_data.fetch('uploaded_at')).utc.to_datetime
      )
    end

    def parse_challenger_data(side) # rubocop:disable Metrics/MethodLength
      rcd = @raw_data.fetch("player#{side}_info")
      Challenger.new(
        player_sid: rcd.fetch('player').fetch('short_id'),
        name: rcd.fetch('player').fetch('fighter_id'),
        character: rcd.fetch('character_id'),
        playing_character: rcd.fetch('playing_character_id'),
        control_type: rcd.fetch('battle_input_type'),
        master_rating: rcd.fetch('master_rating'),
        league_point: rcd.fetch('league_point'),
        rounds: rcd.fetch('round_results'),
        side:
      )
    end
  end
end
