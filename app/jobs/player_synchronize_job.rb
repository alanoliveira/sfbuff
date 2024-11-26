class PlayerSynchronizeJob < ApplicationJob
  include StreamableResultJob

  queue_as :default

  def perform(short_id)
    Synchronizer.new(short_id:).synchronize!

    cache_result(inline: "<%= turbo_stream.action(:refresh, nil) %>")
  end
end
