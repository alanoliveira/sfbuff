class Fighters::ScoreByDateChartsController < Matchups::ScoreByDateChartsController
  include FighterScoped

  fresh_when_unsynchronized
end
