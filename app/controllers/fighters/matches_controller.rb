class Fighters::MatchesController < ApplicationController
  include FighterScoped
  include SetMatchesFilter
  layout "fighter"

  def show
    @matches = @matches_filter.filter(@fighter.matches)
  end
end
