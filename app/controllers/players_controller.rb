# frozen_string_literal: true

class PlayersController < ApplicationController
  # GET /players
  def index; end

  # GET /players/:sid
  def show
    @player = Player.find(params[:sid])
    @filter = PlayerBattlesFilter.new(filter_params)
    @battles = @player.battles.includes(:p1, :p2).where(@filter.as_where).reorder(played_at: :desc)
    @page_battles = @battles.page(params[:page])

    render partial: 'battles' if turbo_frame_request_id == 'battle-list'
  rescue ActiveRecord::RecordNotFound
    # do nothing
  end

  private

  def filter_params
    params.permit(PlayerBattlesFilter.attribute_names)
  end
end
