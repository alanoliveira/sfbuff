class SearchesController < ApplicationController
  def show
    @query = params[:q].presence
  end

  def create
    @search_request = SearchRequest.create(query: params[:query])
    @search_request.process_later!
  end
end
