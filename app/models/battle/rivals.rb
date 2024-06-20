# frozen_string_literal: true

class Battle
  class Rivals
    Rival = Data.define(:player_sid, :name, :character, :control_type,
                        :wins, :loses, :draws, :diff, :total)

    def initialize(pov)
      @rel = pov
             .group('opponent.character', 'opponent.control_type', 'opponent.player_sid')
             .select('opponent.character', 'opponent.control_type',
                     'opponent.player_sid', 'ANY_VALUE(opponent.name) name')
             .unscope(:order)
    end

    def favorites
      fetch('total DESC')
    end

    def tormentors
      fetch('diff ASC', 'total DESC')
    end

    def victims
      fetch('diff DESC', 'total DESC')
    end

    def limit(limit)
      tap { @limit = limit }
    end

    private

    def fetch(*order)
      @rel.order(order).limit(@limit).as_json.map { |data| Rival.new(**data.excluding('id')) }
    end
  end
end
