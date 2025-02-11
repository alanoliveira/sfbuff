class Fighters::RivalsController < Matchups::RivalsController
  include FighterScoped

  fresh_when_unsynchronized
end
