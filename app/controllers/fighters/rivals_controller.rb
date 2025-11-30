class Fighters::RivalsController < ApplicationController
  include FighterScoped
  include SetMatchesFilter

  def show
    @rivals = Rivals.new(@matches_filter.filter(@fighter.matches))
  end
end
