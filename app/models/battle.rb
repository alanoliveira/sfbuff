class Battle < ApplicationRecord
  include FromReplay

  composed_of_enum :p1_rounds, :p1_rounds, class_name: "Round", array: true
  composed_of_enum :p1_character, :p1_character_id, class_name: "Character"
  composed_of_enum :p1_playing_character, :p1_playing_character_id, class_name: "Character"
  composed_of_enum :p1_input_type, :p1_input_type_id, class_name: "InputType"
  composed_of_enum :p2_rounds, :p2_rounds, class_name: "Round", array: true
  composed_of_enum :p2_character, :p2_character_id, class_name: "Character"
  composed_of_enum :p2_playing_character, :p2_playing_character_id, class_name: "Character"
  composed_of_enum :p2_input_type, :p2_input_type_id, class_name: "InputType"
  composed_of_enum :battle_type, :battle_type_id

  before_save :set_winner_side

  def to_param
    replay_id
  end

  private

  def set_winner_side
    p1_wins = p1_rounds.count(&:win?)
    p2_wins = p2_rounds.count(&:win?)
    self.winner_side = case
    when p1_wins > p2_wins then 1
    when p2_wins > p1_wins then 2
    else 0
    end
  end
end
