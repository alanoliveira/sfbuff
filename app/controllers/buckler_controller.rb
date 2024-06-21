# frozen_string_literal: true

class BucklerController < ApplicationController
  # GET /buckler/player_search?q=
  def player_search
    @search_term = params[:q]
  end
end
