class PlayerSynchronizeChannel < Turbo::StreamsChannel
  def subscribed
    player = fetch_player
    return reject if player.synchronized?
    stream_for player.synchronize!
  end

  private

  def fetch_player
    GlobalID::Locator.locate(verified_stream_name_from_params)
  end
end
