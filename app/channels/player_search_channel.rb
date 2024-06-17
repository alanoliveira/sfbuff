# frozen_string_literal: true

class PlayerSearchChannel < Turbo::StreamsChannel
  def self.broadcast_to(job_id, status, data)
    broadcast_render_to(
      job_id,
      template: 'cable/player_search',
      locals: { status:, data:, job_id: }
    )
  end

  def subscribed
    return reject unless term.length >= 4

    @job_id = PlayerSearchJob.perform_later(term).job_id
    stream_from @job_id
  end

  def unsubscribed
    stop_stream_from(@job_id)
  end

  private

  def term
    params[:term]
  end
end
