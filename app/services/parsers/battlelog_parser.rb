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
      battle.tap do |b|
        b.p1 = p1
        b.p2 = p2
        b.winner_side = winner
        b.raw_battle = RawBattle.new(data: @raw_data)
      end
    end

    private

    def winner
      return @winner if @winner.present?

      p1_rounds = @raw_data.dig('player1_info', 'round_results')
      p2_rounds = @raw_data.dig('player2_info', 'round_results')
      @winner = WinnerEvaluator.evaluate_winner(p1_rounds, p2_rounds)
    end

    def mr_calculator
      return unless battle.ranked?

      @mr_calculator ||= MasterRatingCalculator.new(
        @raw_data.dig('player1_info', 'master_rating'),
        @raw_data.dig('player2_info', 'master_rating'),
        winner
      )
    end

    def battle
      @battle ||= Battle.new(
        replay_id: @raw_data.fetch('replay_id'),
        battle_type: @raw_data.fetch('replay_battle_type'),
        battle_subtype: @raw_data.fetch('replay_battle_sub_type'),
        played_at: Time.at(@raw_data.fetch('uploaded_at')).utc.to_datetime
      )
    end

    def p1
      @p1 ||=
        parse_challenger_data(@raw_data.fetch('player1_info')).tap do |c|
          c.side = 1
          c.mr_variation = mr_calculator.try(:p1_variation)
        end
    end

    def p2
      @p2 ||=
        parse_challenger_data(@raw_data.fetch('player2_info')).tap do |c|
          c.side = 2
          c.mr_variation = mr_calculator.try(:p2_variation)
        end
    end

    def parse_challenger_data(info)
      Challenger.new(
        player_sid: info.fetch('player').fetch('short_id'),
        name: info.fetch('player').fetch('fighter_id'),
        character: info.fetch('character_id'),
        playing_character: info.fetch('playing_character_id'),
        control_type: info.fetch('battle_input_type'),
        master_rating: info.fetch('master_rating'),
        league_point: info.fetch('league_point'),
        rounds: info.fetch('round_results')
      )
    end
  end
end
