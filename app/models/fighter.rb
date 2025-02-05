class Fighter < ApplicationRecord
  include Synchronizable

  composed_of :profile, class_name: "FighterProfile", mapping: { profile: :attributes }, allow_nil: true
  composed_of :fighter_id, class_name: "Fighter::FighterId", mapping: { id: :to_i }, converter: :new

  before_save { self.profile ||= FighterProfile.new(name: "##{id}") }
  after_save_commit :broadcast_replace_header

  validate { errors.add(:id, "is not valid") unless fighter_id.valid? }

  def broadcast_replace_header
    broadcast_replace(target: [ self, "header" ], partial: "fighters/header", locals: { fighter: self })
  end
end
