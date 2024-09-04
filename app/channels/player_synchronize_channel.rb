class PlayerSynchronizeChannel < Turbo::StreamsChannel
  def self.broadcast_response(to:)
    broadcast_action_to(to, action: "refresh")
  end

  def self.broadcast_error(to:, error:)
    broadcast_render_to(to, template: "channel/error", locals: { error: })
  end

  def subscribed
    return reject if short_id.blank?

    @job_id = PlayerSynchronizeJob.perform_later(short_id).job_id
    stream_from @job_id
  end

  def unsubscribed
    stop_stream_from(@job_id)
  end

  private

  def short_id
    verified_stream_name_from_params
  end
end
