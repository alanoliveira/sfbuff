class RankedHistoryChart < ApplicationChart
  include Rails.application.routes.url_helpers

  attr_accessor :ranked_history

  def initialize(ranked_history)
    @ranked_history = ranked_history
  end

  def mr_matches
    @mr_matches ||= ranked_history.filter { it[:mr].positive? }
  end

  def lp_matches
    @lp_matches ||= ranked_history.filter { it[:lp].positive? }
  end

  def mr_data
    @mr_data ||= mr_matches.map { dataset_item(played_at: it[:played_at], value: it[:mr], variation: it[:mr_variation], replay_id: it[:replay_id]) }
  end

  def future_mr_data
    last_mr_match = mr_matches.last
    @future_mr_data ||= [
      dataset_item(played_at: last_mr_match[:played_at], value: last_mr_match[:mr]),
      dataset_item(played_at: last_mr_match[:played_at], value: last_mr_match[:mr] + last_mr_match[:mr_variation].to_i)
    ]
  end

  def lp_data
    @lp_data ||= lp_matches.map { dataset_item(played_at: it[:played_at], value: it[:lp], variation: it[:lp_variation], replay_id: it[:replay_id]) }
  end

  def future_lp_data
    last_lp_match = lp_matches.last
    @future_lp_data ||= [
      dataset_item(played_at: last_lp_match[:played_at], value: last_lp_match[:lp]),
      dataset_item(played_at: last_lp_match[:played_at], value: last_lp_match[:lp] + last_lp_match[:lp_variation].to_i)
    ]
  end

  private

  def dataset_item(played_at:, value:, variation: nil, replay_id: nil)
    variation = variation ? ("%+d" % variation) : "?"
    {
      "x" => played_at,
      "y" => value,
      "label" => "#{value} (#{variation})",
      "visit" => (battle_path(replay_id) if replay_id)
    }
  end
end
