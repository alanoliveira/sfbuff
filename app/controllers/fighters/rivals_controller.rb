class Fighters::RivalsController < ApplicationController
  include FighterScoped
  include SetMatchesFilter
  fresh_when_synchronized_at_changed

  def show
    @rivals = Rivals.new(@matches_filter.filter(@fighter.matches))
  end
end
