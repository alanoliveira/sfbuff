# frozen_string_literal: true

class Battle
  module Rivals
    Rival = Data.define(:player_sid, :name, :character, :control_type,
                        :wins, :loses, :draws, :diff, :total)

    def self.extended(base)
      base.group_values += ['opponent.character', 'opponent.control_type', 'opponent.player_sid']
      base.select_values += ['opponent.character', 'opponent.control_type',
                             'opponent.player_sid', 'ANY_VALUE(opponent.name) name']
    end

    def favorites
      order('total DESC').fetch
    end

    def tormentors
      order('diff ASC', 'total DESC').fetch
    end

    def victims
      order('diff DESC', 'total DESC').fetch
    end

    def fetch
      as_json.map { |data| Rival.new(**data.excluding('id')) }
    end
  end
end
