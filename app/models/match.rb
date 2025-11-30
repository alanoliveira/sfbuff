class Match < ApplicationRecord
  composed_of_enum :home_rounds, :home_round_ids, class_name: "Round", array: true
  composed_of_enum :home_character, :home_character_id, class_name: "Character"
  composed_of_enum :home_playing_character, :home_playing_character_id, class_name: "Character"
  composed_of_enum :home_input_type, :home_input_type_id, class_name: "InputType"
  composed_of_enum :away_rounds, :away_round_ids, class_name: "Round", array: true
  composed_of_enum :away_character, :away_character_id, class_name: "Character"
  composed_of_enum :away_playing_character, :away_playing_character_id, class_name: "Character"
  composed_of_enum :away_input_type, :away_input_type_id, class_name: "InputType"
  composed_of_enum :battle_type, :battle_type_id
  composed_of_enum :result, :result

  scope :ranked, -> { where(battle_type: BattleType::RANKED) }

  def self.aggregate_results
    ResultAggregation.new(all)
  end

  def self.daily_results
    group_by_day(:played_at)
      .then { it.select("#{it.group_values.last} date") }
      .order("date")
      .aggregate_results
      .to_h { |data, score| [ data["date"], score ] }
  end

  def readonly?
    true
  end
end
