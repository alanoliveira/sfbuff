class FighterSearchesController < ApplicationController
  rate_limit to: 5, within: 1.minutes, only: :create
  before_action :set_fighter_search, only: :show

  def new
    @query = params[:q].presence
  end

  def create
    @fighter_search = FighterSearch.new(query: params[:query])

    if @fighter_search.save
      @fighter_search.process_later
    else
      head :unprocessable_content
    end
  end

  def show
    head :accepted unless @fighter_search.finished?
  end

  private

  def set_fighter_search
    @fighter_search = FighterSearch.find(params[:id])
  end
end
