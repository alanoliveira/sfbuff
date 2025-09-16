class Fighter < ApplicationRecord
  include Synchronizable

  FIGHTER_ID_REGEXP = /\d{9,}/.freeze

  composed_of :profile, class_name: "FighterProfile", mapping: { profile: :attributes }, allow_nil: true
  has_many :character_league_infos

  after_initialize { self.profile ||= FighterProfile.new(name: "##{id}") }

  validates :id, format: Regexp.union(/\A/, FIGHTER_ID_REGEXP, /\z/)
end
