class PlayerSearchChannel < ApplicationCable::JobTurboStreamsChannel
  alias term verified_stream_name_from_params

  def self.broadcast_response(to:, data:)
    if data.any?
      broadcast_replace_to(to, partial: "fighter_banners/table", locals: { data: })
    else
      broadcast_replace_to(to, inline: "<%= no_data_alert %>")
    end
  end

  def self.broadcast_error(to:, error:)
    broadcast_replace_to(to, inline: "<%= error_alert error %>", locals: { error: })
  end

  def create_job
    PlayerSearchJob.perform_later(term)
  end
end
