# frozen_string_literal: true

require 'sfbuff/active_model/type/period'

ActiveModel::Type::register(:period, Sfbuff::ActiveModel::Type::Period)
