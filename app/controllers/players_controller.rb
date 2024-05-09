# frozen_string_literal: true

class PlayersController < ApplicationController
  # GET /players
  def index; end

  # GET /players/:sid
  def show
    @player = Player.find(params[:sid])
    battles = PlayerBattles.fetch(@player.sid)
                           .using_character(params[:player_character])
                           .using_control_type(params[:player_control_type])
                           .vs_character(params[:vs_character])
                           .vs_control_type(params[:vs_control_type])
    @rivals = Rivals.fetch(battles)
    @battles = battles.page(params[:page])

    render partial: 'battles' if turbo_frame_request_id == 'battle-list'
  rescue ActiveRecord::RecordNotFound
  end
end
