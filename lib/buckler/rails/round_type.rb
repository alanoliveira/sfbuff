module Buckler
  module Rails
    class RoundType < ActiveRecord::Type::Value
      def serialize(value)
        value.to_i
      end

      private

      def cast_value(value)
        Buckler::Round.new(value)
      end
    end
  end
end
