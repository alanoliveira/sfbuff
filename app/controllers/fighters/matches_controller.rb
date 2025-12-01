class Fighters::MatchesController < ApplicationController
  include FighterScoped
  include SetMatchesFilter
  layout "fighter"

  def show
    @pagy, @matches = pagy(:offset, @matches_filter.filter(@fighter.matches).order(played_at: :desc))
  end
end
