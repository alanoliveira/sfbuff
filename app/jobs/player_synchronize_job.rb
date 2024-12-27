class PlayerSynchronizeJob < ApplicationJob
  queue_as :default

  def perform(player_synchronize_process)
    player_synchronize_process.execute
  end
end
