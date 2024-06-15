# frozen_string_literal: true

class PlayersController < ApplicationController
  before_action :set_player, only: %i[show battles ranked matchup_chart]

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
    @action = BattlesAction.new(
      params,
      player_sid: @player.sid,
      page: params[:page]
    )

    render partial: 'battles', locals: { battles: @action.battles } if turbo_frame_request_id == 'battle-list'
  end

  # GET /players/:sid/ranked
  def ranked
    @action = RankedAction.new(
      params,
      player_sid: @player.sid,
      character: @player.main_character
    )
  end

  # GET /players/:sid/matchup_chart
  def matchup_chart
    @action = MatchupChartAction.new(
      params,
      player_sid: @player.sid,
      character: @player.main_character
    )
  end

  private

  def set_player
    @player = Player.find_or_initialize_by(sid: params[:sid])

    render html: nil, layout: true if @player.new_record?
  end
end
