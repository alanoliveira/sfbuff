class Player < ApplicationRecord
  cattr_accessor :synchronized_threshold, default: 10.minutes

  has_one :synchronize_process, -> { active },
    class_name: "PlayerSynchronizeProcess",
    primary_key: :short_id, foreign_key: :short_id

  attribute :short_id, :buckler_short_id
  attribute :main_character, :buckler_character

  def self.find_or_create(short_id)
    find_or_create_by(short_id:) do |p|
      p.name = "##{short_id}"
    end
  end

  after_save_commit :broadcast_replace_header_later

  def synchronized?
    synchronized_at.present? && synchronized_at > synchronized_threshold.ago
  end

  def synchronize!
    return if synchronized?
    sync_proc = with_lock { synchronize_process || create_synchronize_process! }
    PlayerSynchronizeJob.perform_later(sync_proc) if sync_proc.previously_new_record?
    sync_proc
  end

  def to_param
    short_id.to_s
  end

  def broadcast_replace_header_later
    broadcast_replace_later(target: [ self, "header" ], partial: "players/header", player: self)
  end
end
