class PlayerSynchronizeChannel < ApplicationCable::JobTurboStreamsChannel
  alias short_id verified_stream_name_from_params

  def self.broadcast_response(to:, data:)
    broadcast_action_to(to, action: "refresh")
  end

  def self.broadcast_error(to:, error:)
    broadcast_replace_to(to, inline: "<%= error_alert error: %>", locals: { error: })
  end

  def create_job
    PlayerSynchronizeJob.perform_later(short_id)
  end
end
