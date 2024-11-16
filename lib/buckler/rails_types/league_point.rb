module Buckler
  module RailsTypes
    class LeaguePoint < ActiveRecord::Type::Value
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
