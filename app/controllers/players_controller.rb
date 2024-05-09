# frozen_string_literal: true

class PlayersController < ApplicationController
  # GET /players
  def index; end

  # GET /players/:sid
  def show
    @player = Player.find(params[:sid])
    battles = PlayerBattles.fetch(@player.sid)
    @rivals = Rivals.fetch(battles)
    @battles = battles.page(params[:page])

    render partial: 'battles' if turbo_frame_request_id == 'battle-list'
  rescue ActiveRecord::RecordNotFound
  end
end
