class Players::BattlesController < ApplicationController
  include Players::MatchupScope
  include Pagyable
  include PlayerScope
  include SetCurrentMatchupFilter

  def show
    @matchup = CurrentMatchupFilter.matchup
    @pagy, @page_matchups = pagy(@matchup.order(played_at: :desc)).then do |pagy, page_matchups|
      [ pagy, cache(page_matchups) { page_matchups.tap(&:load) } ]
    end
  end
end
