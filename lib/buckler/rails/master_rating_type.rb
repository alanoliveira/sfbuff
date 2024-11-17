module Buckler
  module Rails
    class MasterRatingType < ActiveRecord::Type::Value
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
