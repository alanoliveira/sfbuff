# frozen_string_literal: true

class PlayerSyncChannel < Turbo::StreamsChannel
  def self.broadcast_to(job_id, status, data)
    Turbo::StreamsChannel.broadcast_render_to(
      job_id,
      template: 'cable/player_sync',
      locals: { status:, data:, job_id: }
    )
  end

  def subscribed
    return reject if player_sid.blank?

    @job_id = PlayerSyncJob.perform_later(player_sid).job_id
    stream_from @job_id
  end

  def unsubscribed
    stop_stream_from(@job_id)
  end

  private

  def player_sid
    verified_stream_name_from_params
  end
end
