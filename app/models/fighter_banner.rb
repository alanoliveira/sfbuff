class FighterBanner
  include ActiveModel::API
  include ActiveModel::Attributes

  attribute :short_id, :buckler_short_id
  attribute :name
  attribute :main_character, :buckler_character
  attribute :master_rating, :buckler_master_rating
  attribute :league_point, :buckler_league_point
  attribute :home_id, :buckler_home_id
end
