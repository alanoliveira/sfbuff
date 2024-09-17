class Players::BaseController < ApplicationController
  before_action :set_player

  layout "players"

  def cache_store
    super.with_options version: @player.cache_key_with_version, expires_in: 5.minutes
  end

  private

  def set_player
    @player = Player.find_or_initialize_by(short_id: params[:player_short_id])
  end
end
