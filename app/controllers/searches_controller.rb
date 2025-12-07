class SearchesController < ApplicationController
  rate_limit to: 5, within: 1.minutes, only: :create

  def show
    @query = params[:q].presence
  end

  def create
    @search_request = SearchRequest.new(query: params[:query])

    if @search_request.save
      @search_request.process_later!
    else
      head :unprocessable_content
    end
  end
end
