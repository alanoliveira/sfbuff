# frozen_string_literal: true

class Battle
  module Pov
    def self.extended(base)
      base
        .joins!('INNER JOIN challengers AS player ON battles.id = player.battle_id
                 INNER JOIN challengers AS opponent ON battles.id = opponent.battle_id
                        AND player.player_sid != opponent.player_sid')
    end

    def rivals
      statistics.extending(Rivals)
    end

    protected

    def statistics
      reselect(
        Arel.sql('COUNT(nullif(winner_side = opponent.side, true)) wins'),
        Arel.sql('COUNT(nullif(winner_side = player.side, true)) loses'),
        Arel.sql('COUNT(nullif(winner_side = opponent.side, true)) -
                    COUNT(nullif(winner_side = player.side, true)) diff'),
        'COUNT(1) total'
      ).unscope(:order, :limit, :offset)
    end
  end
end
