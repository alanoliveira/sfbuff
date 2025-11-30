class Fighters::MatchesController < ApplicationController
  include FighterScoped
  layout "fighter"

  def show
    @matches = Match.all
  end
end
