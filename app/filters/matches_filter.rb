class MatchesFilter
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :played_from
  attribute :played_to
  attribute :battle_type_id
  attribute :home_fighter_id
  attribute :home_character_id
  attribute :home_input_type_id
  attribute :away_fighter_id
  attribute :away_character_id
  attribute :away_input_type_id

  def filter(matches)
    matches.where({
      home_fighter_id: home_fighter_id,
      home_character_id: home_character_id,
      home_input_type_id: home_input_type_id,
      away_fighter_id: away_fighter_id,
      away_character_id: away_character_id,
      away_input_type_id: away_input_type_id,
      battle_type_id: battle_type_id,
      played_at: played_from..played_to
    }.compact_blank)
  end
end
