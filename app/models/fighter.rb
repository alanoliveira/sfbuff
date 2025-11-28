class Fighter < ApplicationRecord
  include FromFighterBanner

  validates :id, format: Patterns::SHORT_ID_REGEXP
end
