# frozen_string_literal: true

class PlayersController < ApplicationController
  # GET /players
  def index; end

  # GET /players/:sid
  def show
    @player = Player.find(params[:sid])
  rescue ActiveRecord::RecordNotFound
  end
end
