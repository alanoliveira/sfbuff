class Challenger < ApplicationRecord
  include Sti

  lookup_enum :character
  lookup_enum :playing_character, class_name: "Character"
  lookup_enum :input_type
end
