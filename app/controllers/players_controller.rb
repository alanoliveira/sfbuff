# frozen_string_literal: true

class PlayersController < ApplicationController
  # GET /players
  def index; end

  # GET /players/:sid
  def show
    @player = Player.find(params[:sid])
    @filter = PlayerBattlesFilter.new(filter_params)
    battles = @filter.inject(@player.battles)
    @rivals = Rivals.fetch(battles)
    @battles = battles.page(params[:page])

    render partial: 'battles' if turbo_frame_request_id == 'battle-list'
  rescue ActiveRecord::RecordNotFound
    # do nothing
  end

  private

  def filter_params
    params.permit(PlayerBattlesFilter.attribute_names)
  end
end
