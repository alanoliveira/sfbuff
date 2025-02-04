class Fighter < ApplicationRecord
  composed_of :profile, class_name: "FighterProfile", mapping: { profile: :attributes }, allow_nil: true
  composed_of :fighter_id, class_name: "Fighter::FighterId", mapping: { id: :to_i }, converter: :new

  before_save { self.profile ||= FighterProfile.new(name: "##{id}") }

  validate { errors.add(:id, "is not valid") unless fighter_id.valid? }
end
