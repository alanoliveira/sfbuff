# frozen_string_literal: true

class PlayersController < ApplicationController
  before_action :set_player, only: %i[show battles ranked]

  # GET /players
  def index
    @search_term = params[:q]
  end

  # GET /players/:sid
  def show
    redirect_to battles_player_url(@player)
  end

  # GET /players/:sid/battles
  def battles
    @battles_action = BattlesAction.new(params, player: @player)
    @battles = @battles_action.battles
    @page_battles = @battles.page(params[:page])

    return render partial: 'battles' if turbo_frame_request_id == 'battle-list'

    render 'battles'
  end

  # GET /players/:sid/ranked
  def ranked; end

  private

  def set_player
    @player = Player.find_or_initialize_by(sid: params[:sid])

    render html: nil, layout: true if @player.new_record?
  end

  def filter_params
    params.permit(PlayerBattlesFilter.attribute_names)
  end
end
