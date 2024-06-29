# frozen_string_literal: true

class Battle
  class MatchupChart
    ROW_DEFAULTS = { wins: nil, loses: nil, draws: nil, diff: nil, total: nil }.freeze

    Row = Data.define(:character, :control_type, :wins, :loses, :draws, :diff, :total) do
      def initialize(*, **)
        super(ROW_DEFAULTS.merge(*, **))
      end
    end

    delegate :any?, to: :result_list

    def initialize(pov)
      @pov = pov.regroup('opponent.character', 'opponent.control_type')
    end

    def each(&)
      char_x_control.map do |character, control_type|
        result_list.find do |r|
          [r.character, r.control_type] == [character, control_type]
        end || Row.new(character, control_type)
      end.each(&)
    end

    def sum
      res = result_list.reduce do |total, row|
        row.to_h.merge(total.to_h) { |_, a, b| a + b }
      end
      Row.new(character: nil, control_type: nil, **res)
    end

    private

    def result_list
      @result_list ||=
        @pov.pluck('opponent.character', 'opponent.control_type', *@pov.select_values).map do |raw_data|
          Row.new(*raw_data)
        end
    end

    def char_x_control
      Buckler::CHARACTERS.values.product(Buckler::CONTROL_TYPES.values)
    end
  end
end
