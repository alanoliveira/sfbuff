class Fighters::MatchesController < ApplicationController
  include FighterScoped
  include SetMatchesFilter
  fresh_when_synchronized_at_changed
  layout "fighter"

  def show
    @pagy, @matches = pagy(:offset, @matches_filter.filter(@fighter.matches).order(played_at: :desc))
  end
end
