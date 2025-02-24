class RankedHistoriesController < ApplicationController
  include FighterScoped

  layout :fighter_layout
  before_action { params.compact_blank!.with_defaults!(default_params) }
  fresh_when_unsynchronized
  fragment_cache_key { @fighter.last_synchronized_replay_id }

  def show
    @ranked_history = RankedHistory.new(ranked_history_params)
  end

  private

  def ranked_history_params
    hash = params.permit(:fighter_id, :home_character, :played_from, :played_to).to_h
    hash[:character] = hash.delete(:home_character)
    hash
  end

  def default_params
    { home_character: @fighter.profile.main_character&.id }
  end
end
