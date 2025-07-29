class FighterProfile
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :fighter_id
  attribute :name
  attribute :main_character_id
  attribute :mr
  attribute :lp
  attribute :home_id
  attribute :last_online_at

  # Methods to ensure previous FighterProfiles
  # still work after name change
  alias master_rating= mr=
  alias league_point= lp=

  def inspect
    "#<#{self.class}: #{attributes}>"
  end
end
