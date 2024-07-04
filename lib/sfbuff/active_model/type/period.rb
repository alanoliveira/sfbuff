# frozen_string_literal: true

module Sfbuff
  module ActiveModel
    module Type
      class Period < ::ActiveModel::Type::Value
        private

        def cast_value(value)
          ::Period.new(value)
        end
      end
    end
  end
end
