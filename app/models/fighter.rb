class Fighter < ApplicationRecord
  include Synchronizable
  include FromFighterBanner

  has_many :matches, foreign_key: :home_fighter_id

  validates :id, format: Patterns::SHORT_ID_REGEXP
end
