class FighterSearchesController < ApplicationController
  rate_limit to: 5, within: 1.minutes, only: :create

  def new
    @query = params[:q].presence
  end

  def create
    @search_request = SearchRequest.new(query: params[:query])

    unless @search_request.save
      head :unprocessable_content
    end
  end
end
