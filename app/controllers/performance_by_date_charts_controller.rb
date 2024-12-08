class PerformanceByDateChartsController < ApplicationController
  include SetCurrentMatchupFilter

  def show
    return head :unprocessable_entity if CurrentMatchupFilter.home_short_id.nil? &&
      (CurrentMatchupFilter.home_character.nil? || CurrentMatchupFilter.home_control_type.nil?)

    @matchup = CurrentMatchupFilter.matchup
  end
end
