# frozen_string_literal: true

class Battle
  module Pov
    def self.extended(base)
      base
        .joins!('INNER JOIN challengers AS player ON battles.id = player.battle_id
           INNER JOIN challengers AS opponent ON battles.id = opponent.battle_id
                  AND player.player_sid != opponent.player_sid')
    end

    def rivals(*grouping_by)
      Rivals.new(self, *grouping_by)
    end
  end
end
