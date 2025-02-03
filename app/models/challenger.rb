class Challenger < ApplicationRecord
  include Sti

  lookup_enum :character
  lookup_enum :playing_character, class_name: "Character"
  lookup_enum :input_type
  delegate :result, to: :round_set

  def round_set
    RoundSet.new(round_ids)
  end
end
