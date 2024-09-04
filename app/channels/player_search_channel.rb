class PlayerSearchChannel < Turbo::StreamsChannel
  RESULT_TARGET = "player-search-result"

  def self.broadcast_response(to:, data:)
    broadcast_render_to(to, template: "channel/player_search/response",
      locals: { target: RESULT_TARGET, data: })
  end

  def self.broadcast_error(to:, error:)
    broadcast_render_to(to, template: "channel/error",
      locals: { target: RESULT_TARGET, error: })
  end

  def subscribed
    return reject if term.blank?

    @job_id = PlayerSearchJob.perform_later(term).job_id
    stream_from @job_id
  end

  def unsubscribed
    stop_stream_from(@job_id)
  end

  private

  def term
    verified_stream_name_from_params
  end
end
