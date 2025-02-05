class FighterSearchesController < ApplicationController
  def create
    @fighter_search = FighterSearch.new(fighter_search_params)
    return head :unprocessable_entity unless @fighter_search.valid?

    @fighter_search.search_later
  end

  private

  def fighter_search_params
    params.expect(fighter_search: [ :query ])
  end
end
