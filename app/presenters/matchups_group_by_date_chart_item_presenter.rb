MatchupsGroupByDateChartItemPresenter = Struct.new(:value, :label, :description) do
  def self.from_result_query(item)
    group, score = item.to_a.flatten

    label = group["date"].iso8601
    value = score.diff
    description = "W:#{score.win} L:#{score.lose} Σ:#{score.diff}"

    new(value:, label:, description:)
  end
end
