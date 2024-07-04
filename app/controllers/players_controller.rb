# frozen_string_literal: true

class PlayersController < ApplicationController
  before_action :set_player, only: %i[show]

  # GET /players/:sid
  def show
    redirect_to player_battles_url(@player)
  end

  private

  def set_player
    @player = Player.find_or_initialize_by(sid: params[:sid])

    render html: nil, layout: true if @player.new_record?
  end
end
