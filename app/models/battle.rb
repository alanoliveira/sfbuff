class Battle < ApplicationRecord
  enum :battle_type, { "ranked" => 1, "casual_match" => 2, "battle_hub" => 3, "custom_room" => 4 }
end
