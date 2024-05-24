# frozen_string_literal: true

class PlayersController < ApplicationController
  before_action :set_player, only: %i[show battles]

  # GET /players
  def index; end

  # GET /players/:sid
  def show
    redirect_to battles_player_url(@player)
  end

  def battles
    @filter = PlayerBattlesFilter.new(filter_params)
    @battles = @player.battles.includes(:p1, :p2).where(@filter.as_where).reorder(played_at: :desc)
    @page_battles = @battles.page(params[:page])

    return render partial: 'battles' if turbo_frame_request_id == 'battle-list'

    render 'battles'
  end

  private

  def set_player
    @player = Player.find_or_initialize_by(sid: params[:sid])

    render html: nil, layout: true if @player.new_record?
  end

  def filter_params
    params.permit(PlayerBattlesFilter.attribute_names)
  end
end
