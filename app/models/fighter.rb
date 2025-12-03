class Fighter < ApplicationRecord
  include Synchronizable
  include FromFighterBanner

  has_many :matches, foreign_key: :home_fighter_id
  has_many :current_league_infos, dependent: :delete_all do
    def [](character)
      to_a.find { it.character_id == character.to_i }
    end
  end

  validates :id, format: /\A#{Patterns::SHORT_ID_REGEXP.source}\z/
end
