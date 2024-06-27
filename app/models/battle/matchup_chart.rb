# frozen_string_literal: true

class Battle
  class MatchupChart
    ROW_DEFAULTS = { wins: nil, loses: nil, draws: nil, diff: nil, total: nil }.freeze

    Row = Data.define(:character, :control_type, :wins, :loses, :draws, :diff, :total) do
      def initialize(**)
        super(ROW_DEFAULTS.merge(**))
      end
    end

    def initialize(pov)
      @data = pov
              .group('opponent.character', 'opponent.control_type')
              .select('opponent.character', 'opponent.control_type')
              .as_json
              .map { _1.excluding('id') }
    end

    def each(&)
      product = Buckler::CHARACTERS.values.product(Buckler::CONTROL_TYPES.values)
      product.map do |character, control_type|
        create_row(character, control_type)
      end.each(&)
    end

    def sum
      s = @data.reduce do |total, row|
        row.merge(total) { |_, a, b| a + b }
      end
      Row.new(character: nil, control_type: nil, **s)
    end

    def any?
      @data.any?
    end

    private

    def create_row(character, control_type)
      res = @data.find do |d|
        d['character'] == character && d['control_type'] == control_type
      end
      Row.new(character:, control_type:, **Hash(res))
    end
  end
end
