class FighterProfile
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :fighter_id
  attribute :name
  attribute :main_character_id
  attribute :master_rating
  attribute :league_point
  attribute :home_id
  attribute :last_online_at

  def main_character
    Character[main_character_id]
  end

  def league_info
    LeagueInfo.new(lp: league_point, mr: master_rating)
  end

  def home
    Home[home_id]
  end
end
