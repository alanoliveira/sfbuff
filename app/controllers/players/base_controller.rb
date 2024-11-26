class Players::BaseController < ApplicationController
  before_action :set_player
  before_action :synchronize_player, unless: -> { @player.synchronized? }

  layout "players"

  def cache_store
    super.with_options version: @player.cache_key_with_version, expires_in: 5.minutes
  end

  private

  def set_player
    @player = Player.find_or_initialize_by(short_id: params[:short_id])
  end

  def synchronize_player
    @synchronize_job_id = PlayerSynchronizeJob.perform_later(@player.short_id).job_id if trustable?
  end
end
