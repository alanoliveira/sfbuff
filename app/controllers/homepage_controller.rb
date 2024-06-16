# frozen_string_literal: true

class HomepageController < ApplicationController
  # GET /players
  def index
    @search_term = params[:q]
  end
end
