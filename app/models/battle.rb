class Battle < ApplicationRecord
  has_many :challengers, dependent: :destroy
end
