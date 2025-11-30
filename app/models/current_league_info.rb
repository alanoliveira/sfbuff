class CurrentLeagueInfo < ApplicationRecord
  include FromCharacterLeagueInfo
  belongs_to :fighter
  composed_of_enum :character, :character_id
end
