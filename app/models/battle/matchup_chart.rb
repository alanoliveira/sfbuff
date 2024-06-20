# frozen_string_literal: true

class Battle
  class MatchupChart
    Row = Data.define(:character, :wins, :loses, :draws, :diff, :total)

    def initialize(pov)
      @data = pov
              .group('opponent.character')
              .select('opponent.character')
              .as_json
              .map { _1.excluding('id') }
    end

    def fetch
      Buckler::CHARACTERS.transform_values do |char_id|
        @data.find { _1['character'] == char_id }.try { Row.new(**_1) }
      end
    end

    def sum
      zeroes = Row.members.index_with { 0 }
      s = @data.reduce(zeroes) do |total, row|
        total.merge(row) { |k, a, b| a + b unless k == 'character' }
      end
      Row.new(**s)
    end
  end
end
