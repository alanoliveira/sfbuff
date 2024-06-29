# frozen_string_literal: true

class Battle
  class Rivals
    Rival = Data.define(:player_sid, :name, :character, :control_type,
                        :wins, :loses, :draws, :diff, :total)

    def initialize(pov)
      @pov = pov.regroup('opponent.character', 'opponent.control_type', 'opponent.player_sid')
                .reorder('total')
    end

    def favorites
      rival_list.sort do |a, b|
        [-a.total, a.diff.abs] <=> [-b.total, b.diff.abs]
      end
    end

    def tormentors
      rival_list.sort do |a, b|
        [a.diff, -a.loses, a.wins] <=> [b.diff, -b.loses, b.wins]
      end
    end

    def victims
      rival_list.sort do |a, b|
        [-a.diff, -a.wins, -a.loses] <=> [-b.diff, -b.wins, -b.loses]
      end
    end

    private

    def rival_list
      @rival_list ||=
        @pov.pluck('opponent.player_sid',
                   'ANY_VALUE(opponent.name) name',
                   'opponent.character',
                   'opponent.control_type',
                   *@pov.select_values)
            .map { |data| Rival.new(Integer(data[0]), *data[1..]) }
    end
  end
end
