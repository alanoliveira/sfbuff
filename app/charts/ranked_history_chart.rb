class RankedHistoryChart < ApplicationChart
  include Rails.application.routes.url_helpers

  attr_accessor :ranked_history, :current_league

  def initialize(ranked_history, current_league)
    @ranked_history = ranked_history
    @current_league = current_league
  end

  def mr_data
    @mr_data ||= matches_mr_data.tap do
      it.push(current_mr_data) if add_current_mr?
    end
  end

  def lp_data
    @lp_data ||= matches_lp_data.tap do
      it.push(current_lp_data) if add_current_lp?
    end
  end

  private

  def matches_mr_data
    mr_matches.map do
      dataset_item(
        x: it.played_at,
        y: it.mr,
        label: generate_label(value: it.mr, variation: it.mr_variation),
        visit: battle_path(it.replay_id)
      )
    end
  end

  def mr_matches
    ranked_history.filter { it[:mr].positive? }
  end

  def current_mr_data
    dataset_item(x: now, y: current_league.mr, label: number_with_delimiter(current_league.mr), title: t(".current"))
  end

  def matches_lp_data
    lp_matches.map do
      dataset_item(
        x: it.played_at,
        y: it.lp,
        label: generate_label(value: it.lp),
        visit: battle_path(it.replay_id)
      )
    end
  end

  def lp_matches
    ranked_history.filter { it[:lp].positive? }
  end

  def current_lp_data
    dataset_item(x: now, y: current_league.lp, label: number_with_delimiter(current_league.lp), title: t(".current"))
  end

  def add_current_mr?
    cover_today? && current_league.present? && current_league.mr.positive?
  end

  def add_current_lp?
    cover_today? && current_league.present? && current_league.lp.positive?
  end

  def cover_today?
    ranked_history.to_date >= now.to_date
  end

  def generate_label(value:, variation: nil)
    if variation.present?
      sprintf("%s (%+d)", number_with_delimiter(value), variation)
    else
      sprintf("%s", number_with_delimiter(value))
    end
  end

  def dataset_item(x:, y:, label: nil, visit: nil, title: nil)
    { "x" => x, "y" => y, "label" => label, "visit" => visit, "title" => title }
  end

  def now
    @now ||= Time.zone.now
  end
end
