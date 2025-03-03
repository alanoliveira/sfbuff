class Fighter < ApplicationRecord
  include Synchronizable

  FIGHTER_ID_REGEXP = /\d{9,}/.freeze

  composed_of :profile, class_name: "FighterProfile", mapping: { profile: :attributes }, allow_nil: true

  after_initialize { self.profile ||= FighterProfile.new(name: "##{id}") }
  after_save_commit :broadcast_replace_header

  validates :id, format: Regexp.union(/\A/, FIGHTER_ID_REGEXP, /\z/)

  def broadcast_replace_header
    broadcast_replace(target: [ self, "header" ], partial: "fighters/header", locals: { fighter: self })
  end
end
