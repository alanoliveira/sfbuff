class RivalsController < ApplicationController
  include SetCurrentMatchupFilter

  def show
    @rivals = Rivals.new(CurrentMatchupFilter.matchup, limit: 10)
  end
end
