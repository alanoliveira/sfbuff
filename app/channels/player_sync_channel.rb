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
    return reject unless player_sid.to_s[Buckler::Api::SHORT_ID_REGEX]

    @job_id = PlayerSyncJob.perform_later(player_sid).job_id
    stream_from @job_id
  end

  def unsubscribed
    stop_stream_from(@job_id)
  end

  private

  def player_sid
    params[:player_sid]
  end
end
