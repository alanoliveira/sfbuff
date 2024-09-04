class PlayerSynchronizeJob < ApplicationJob
  queue_as :default

  rescue_from(StandardError) do |error|
    channel.broadcast_error(to: job_id, error:)

    raise error
  end

  def perform(short_id)
    Synchronizer.new(short_id:).synchronize!

    channel.broadcast_response(to: job_id)
  end

  def channel
    PlayerSynchronizeChannel
  end
end
