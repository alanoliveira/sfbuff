module Buckler
  module Rails
    class LeaguePointType < ActiveRecord::Type::Value
      def serialize(value)
        value.to_i
      end

      private

      def cast_value(value)
        Buckler::LeaguePoint.new(value)
      end
    end
  end
end
