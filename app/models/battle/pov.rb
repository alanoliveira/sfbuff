# frozen_string_literal: true

class Battle
  module Pov
    def self.extended(base)
      base
        .joins!('INNER JOIN challengers AS player ON battles.id = player.battle_id')
        .joins!('INNER JOIN challengers AS opponent ON battles.id = opponent.battle_id
                        AND player.player_sid != opponent.player_sid')
    end

    def statistics
      Statistics.new(self)
    end

    def matchup_chart
      stats = group('opponent.character', 'opponent.control_type').statistics
      Buckler::CHARACTERS.values.product(Buckler::CONTROL_TYPES.values).map do |character, control_type|
        group = { 'character' => character, 'control_type' => control_type }
        stat = stats.find { |s| s.group == group }
        stat || Statistics::Item.new(group:)
      end
    end

    def rivals
      group('opponent.character', 'opponent.control_type', 'opponent.player_sid')
        .select('ANY_VALUE(opponent.name) name')
        .statistics
    end
  end
end
