RankedChartItemPresenter = Struct.new(:x, :y, :label, :link, :kind) do
  def self.from_ranked_history_item(item)
    value, variation, kind = if item.league_point.master?
      [ item.master_rating, item.master_rating_variation, "mr" ]
    else
      [ item.league_point, item.league_point_variation, "lp" ]
    end

    variation_str = case
    when variation.nil? then ""
    when variation.positive? then " + #{variation.abs}"
    when variation.negative? then " - #{variation.abs}"
    else " + 0"
    end

    x = I18n.localize(item.played_at, format: :short)
    y = value + variation.to_i
    label = "#{value.to_i}#{variation_str}"
    link = Rails.application.routes.url_helpers.battle_path(item.replay_id)
    new(x:, y:, label:, link:, kind:)
  end
end
