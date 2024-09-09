class FighterBanner
  include ActiveModel::API
  include ActiveModel::Attributes

  attribute :short_id
  attribute :name
  attribute :main_character
  attribute :master_rating
  attribute :league_point
  attribute :country

  def player_attributes
    attributes.slice("name", "main_character")
  end
end
