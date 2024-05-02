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
      battle.challangers = [
        parse_challanger_data(1),
        parse_challanger_data(2)
      ]
      battle.raw_data = @raw_data.to_json
      battle
    end

    private

    def parse_battle
      Battle.new(
        replay_id: @raw_data.fetch('replay_id'),
        battle_type: @raw_data.fetch('replay_battle_type'),
        battle_subtype: @raw_data.fetch('replay_battle_sub_type'),
        played_at: Time.at(@raw_data.fetch('uploaded_at')).utc.to_datetime
      )
    end

    def parse_challanger_data(side) # rubocop:disable Metrics/MethodLength
      rcd = @raw_data.fetch("player#{side}_info")
      Challanger.new(
        player_sid: rcd.fetch('player').fetch('short_id'),
        name: rcd.fetch('player').fetch('fighter_id'),
        character: rcd.fetch('playing_character_id'),
        control_type: rcd.fetch('battle_input_type'),
        master_rating: rcd.fetch('master_rating'),
        league_point: rcd.fetch('league_point'),
        rounds: rcd.fetch('round_results'),
        side:
      )
    end
  end
end
