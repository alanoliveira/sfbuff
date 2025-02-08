class FighterSearchesController < ApplicationController
  rate_limit to: 10, within: 1.minutes, only: :create, with: -> { too_many_requests }

  def create
    ahoy.track("FighterSearchesController#create", fighter_search_params.to_h)
    @fighter_search = FighterSearch.new(fighter_search_params)
    return head :unprocessable_entity unless @fighter_search.valid?

    @fighter_search.search_later
  end

  private

  def fighter_search_params
    params.expect(fighter_search: [ :query ])
  end
end
