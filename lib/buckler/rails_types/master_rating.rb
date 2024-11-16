module Buckler
  module RailsTypes
    class MasterRating < ActiveRecord::Type::Value
      def serialize(value)
        value.to_i
      end

      private

      def cast_value(value)
        Buckler::MasterRating.new(value)
      end
    end
  end
end
