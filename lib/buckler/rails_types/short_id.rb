module Buckler
  module RailsTypes
    class ShortId < ActiveRecord::Type::Value
      def serialize(value)
        value.to_i
      end

      private

      def cast_value(value)
        Buckler::ShortId.new(value)
      end
    end
  end
end
