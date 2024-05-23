# frozen_string_literal: true

class Battle
  class Rivals
    module Grouping
      def grouping(*args)
        args.inject(self) do |o, group|
          o.public_send("group_by_#{group}")
        end
      end

      def group_by_character
        group('opponent.character')
          .select('opponent.character')
      end

      def group_by_control_type
        group('opponent.control_type')
          .select('opponent.control_type')
      end

      def group_by_opponent
        group('opponent.player_sid')
          .select('opponent.player_sid sid', 'ANY_VALUE(opponent.name) name')
      end
    end

    def initialize(pov, *grouping_by)
      @pov = pov.unscope(:order).reselect(
        Arel.sql('COUNT(nullif(winner_side = opponent.side, true)) wins'),
        Arel.sql('COUNT(nullif(winner_side = player.side, true)) loses'),
        Arel.sql('COUNT(nullif(winner_side = opponent.side, true)) -
                COUNT(nullif(winner_side = player.side, true)) diff'),
        'COUNT(1) total'
      ).extending(Grouping).grouping(*grouping_by)
    end

    def favorites(top = 5)
      fetch('total DESC', top)
    end

    def tormentors(top = 5)
      fetch('diff ASC', top)
    end

    def victims(top = 5)
      fetch('diff DESC', top)
    end

    private

    def fetch(order, limit)
      @pov.order(order).limit(limit).as_json.map do |data|
        ActiveSupport::HashWithIndifferentAccess.new data.excluding('id')
      end
    end
  end
end
