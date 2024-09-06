class FighterBanner
  include ActiveModel::API
  include ActiveModel::Attributes

  attribute :short_id
  attribute :name
  attribute :main_character
  attribute :master_rating
  attribute :league_point
  attribute :country

  def as_player
    Player.find_or_initialize_by(short_id:).tap do |player|
      player.assign_attributes(attributes.slice("name", "main_character"))
    end
  end
end
