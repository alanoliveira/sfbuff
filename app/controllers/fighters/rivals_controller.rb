class Fighters::RivalsController < Matchups::RivalsController
  include FighterScoped

  fresh_when_unsynchronized
  fragment_cache_key { @fighter.last_synchronized_replay_id }
end
