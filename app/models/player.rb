class Player < ApplicationRecord
  attribute :short_id, :buckler_short_id
  attribute :main_character, :buckler_character

  cattr_accessor :synchronized_threshold, default: 10.minutes

  def self.find_or_create(short_id)
    find_or_create_by(short_id:) do |p|
      p.name = "##{short_id}"
    end
  end

  def synchronized?
    synchronized_at.present? && synchronized_at > synchronized_threshold.ago
  end

  def to_param
    short_id.to_s
  end
end
