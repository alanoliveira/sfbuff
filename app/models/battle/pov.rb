# frozen_string_literal: true

class Battle
  module Pov
    Rival = Struct.new(:sid, :name, :character, :control_type, :wins, :loses, :diff, :total)
    RIVAL_PLUCK = [
      'opponent.player_sid',
      Arel.sql('ANY_VALUE(opponent.name)'),
      'opponent.character',
      'opponent.control_type',
      Arel.sql('COUNT(nullif(winner_side = player.side, true)) wins'),
      Arel.sql('COUNT(nullif(winner_side = opponent.side, true)) loses'),
      Arel.sql('COUNT(nullif(winner_side = player.side, true)) -
                COUNT(nullif(winner_side = opponent.side, true)) diff'),
      'COUNT(1) total'
    ].freeze

    def self.extended(base)
      base
        .joins!('INNER JOIN challengers AS player ON battles.id = player.battle_id
           INNER JOIN challengers AS opponent ON battles.id = opponent.battle_id
                  AND player.player_sid != opponent.player_sid')
    end

    def rivals(order: 'total DESC', limit: 5)
      group('opponent.player_sid', 'opponent.character', 'opponent.control_type')
        .reorder(order)
        .limit(limit)
        .pluck(RIVAL_PLUCK)
        .map { |d| Rival.new(d[0].to_i, *d[1..]) }
    end
  end
end
