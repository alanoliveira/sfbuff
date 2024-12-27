class PlayerSynchronizeProcess < ApplicationRecord
  cattr_accessor :stall_threshold, default: 2.minutes

  belongs_to :player, inverse_of: :synchronize_process,
    primary_key: :short_id, foreign_key: :short_id

  scope :unfinished, -> { where(finished_at: nil) }
  scope :active, -> { unfinished.where(created_at: stall_threshold.ago..) }

  after_save_commit :broadcast_result, if: :finished?

  def finished? = !finished_at.nil?
  def error? = finished? && error.present?
  def success? = finished? && error.nil?
  def stalled? = !finished? && created_at < stall_threshold.ago
  def active? = !finished? && !stalled?

  def execute
    self.started_at = Time.zone.now
    synchronizer.run
  rescue => e
    self.error = { "class" => e.class.name, "message" => e.message }
  ensure finish!
  end

  private

  def synchronizer
    @synchronizer ||= PlayerSynchronizer.new(player:)
  end

  def finish!
    self.finished_at = Time.zone.now
    self.imported_battles_count = synchronizer.imported_battles_count
    save!
  end

  def broadcast_result
    broadcast_render_to(PlayerSynchronizeChannel.broadcasting_for(self))
  end
end
