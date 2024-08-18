# frozen_string_literal: true

module ActiveModel
  module Type
    class Period < Value
      private

      def cast_value(value)
        ::Period.new(value)
      end
    end
  end
end

ActiveModel::Type.register(:period, ActiveModel::Type::Period)
