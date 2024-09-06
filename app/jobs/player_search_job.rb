class PlayerSearchJob < ApplicationJob
  queue_as :default

  rescue_from(StandardError) do |error|
    channel.broadcast_error(to: job_id, error:)

    raise error
  end

  def perform(term)
    data = Buckler.new.search_fighter_banner(term:)
    channel.broadcast_response(to: job_id, data:)
  end

  private

  def channel
    PlayerSearchChannel
  end
end
