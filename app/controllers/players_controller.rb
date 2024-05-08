# frozen_string_literal: true

class PlayersController < ApplicationController
  # GET /players
  def index; end

  # GET /players/:sid
  def show
    @player = Player.find(params[:sid])
    @battles = PlayerBattles.fetch(@player.sid)
    @rivals = Rivals.fetch(@battles)
  rescue ActiveRecord::RecordNotFound
  end
end
