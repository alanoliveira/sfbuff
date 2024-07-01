# frozen_string_literal: true

class Battle
  class Statistics
    Item = Struct.new(:group, :wins, :loses, :draws) do
      def total
        return if [wins, loses, draws].any?(&:nil?)

        wins + loses + draws
      end

      def diff
        return if [wins, loses].any?(&:nil?)

        wins - loses
      end

      def +(other)
        Item.new(
          group: nil,
          wins: wins.to_i + other.wins.to_i,
          loses: loses.to_i + other.loses.to_i,
          draws: draws.to_i + other.draws.to_i
        )
      end
    end

    include Enumerable

    def initialize(relation)
      @items = relation.select(
        Arel.sql('COUNT(nullif(winner_side = opponent.side, true)) wins'),
        Arel.sql('COUNT(nullif(winner_side = player.side, true)) loses'),
        Arel.sql('COUNT(nullif(winner_side IS NOT NULL, true)) draws'),
        *relation.group_values
      ).as_json(except: :id).map do |it|
        group = it.slice!('wins', 'loses', 'draws')
        Item.new(**it, group:)
      end
    end

    def each(&)
      @items.each(&)
    end

    def favorites
      @items.sort do |a, b|
        [-a.total, a.diff.abs] <=> [-b.total, b.diff.abs]
      end
    end

    def tormentors
      @items.sort do |a, b|
        [a.diff, -a.loses, a.wins] <=> [b.diff, -b.loses, b.wins]
      end
    end

    def victims
      @items.sort do |a, b|
        [-a.diff, -a.wins, -a.loses] <=> [-b.diff, -b.wins, -b.loses]
      end
    end
  end
end
