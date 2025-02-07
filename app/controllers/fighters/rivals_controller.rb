class Fighters::RivalsController < Matchups::RivalsController
  include FighterScoped

  before_action { fresh_when @fighter }
end
