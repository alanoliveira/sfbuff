class Fighter < ApplicationRecord
  include Synchronizable
  include FromFighterBanner

  has_many :current_leagues, dependent: :delete_all do
    def [](character)
      to_a.find { it.character_id == character.to_i }
    end
  end

  validates :id, format: /\A#{Patterns::SHORT_ID_REGEXP.source}\z/

  def matches
    Match.where(home_fighter_id: id)
  end
end
