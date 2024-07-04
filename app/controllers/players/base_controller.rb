# frozen_string_literal: true

module Players
  class BaseController < ApplicationController
    before_action :set_player
    layout 'players'

    private

    def set_player
      @player = Player.find(params.require(:player_sid))
    end
  end
end
