class Fighter < ApplicationRecord
  include Synchronizable
  include FromFighterBanner

  validates :id, format: Patterns::SHORT_ID_REGEXP
end
