class PlayerSynchronizeJob < ApplicationJob
  include StreamableResultJob

  queue_as :default

  def perform(short_id)
    player = Player.find_or_initialize_by(short_id:)
    PlayerSynchronizer.run(player:)

    cache_result(inline: "<%= turbo_stream.action(:refresh, nil) %>")
  end
end
