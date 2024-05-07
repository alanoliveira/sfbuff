# frozen_string_literal: true

class PlayerSyncsController < ApplicationController
  # GET /buckler/player_syncs/:id
  def show
    @result = PlayerSyncJob.find_job_status!(params[:id])
    return head :accepted if @result[:status] == :waiting

    render
  rescue CacheableJob::JobCacheNotFound
    redirect_to root_url
  end

  # POST /buckler/player_syncs
  def create
    player_sid = params.fetch(:player_sid)
    return head :unprocessable_entity unless player_sid[/\d{9,}/]

    return head :ok if Player.find_by(sid: player_sid).try(&:synchronized?)

    @job = PlayerSyncJob.perform_later(player_sid)
  end
end
