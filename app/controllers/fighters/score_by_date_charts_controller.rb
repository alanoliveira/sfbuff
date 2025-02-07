class Fighters::ScoreByDateChartsController < Matchups::ScoreByDateChartsController
  include FighterScoped

  before_action { fresh_when @fighter }
end
