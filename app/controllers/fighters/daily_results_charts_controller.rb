class Fighters::DailyResultsChartsController < ApplicationController
  include FighterScoped
  include SetMatchesFilter
  fresh_when_synchronized_at_changed
  determine_modal_variant only: "show"

  def show
    @matches = @matches_filter.filter(@fighter.matches)
  end
end
