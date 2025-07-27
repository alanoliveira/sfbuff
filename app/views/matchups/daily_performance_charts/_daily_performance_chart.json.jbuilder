json.type "bar"

json.options do
  json.scales do
    json.x do
      json.stacked true
    end
    json.y do
      json.stacked true
    end
  end
  json.interaction do
    json.mode "index"
  end
end

json.data do
  json.labels data.keys
  json.datasets do
    json.child! do
      json.label I18n.t("attributes.scoreboard.wins", count: 2)
      json.data data.values.map(&:wins)
      json.borderColor ChartsHelper::CHART_COLORS[:green]
      json.backgroundColor ChartsHelper::CHART_COLORS[:green]
    end
    json.child! do
      json.label I18n.t("attributes.scoreboard.draws", count: 2)
      json.data data.values.map(&:draws)
      json.borderColor ChartsHelper::CHART_COLORS[:yellow]
      json.backgroundColor ChartsHelper::CHART_COLORS[:yellow]
    end
    json.child! do
      json.label I18n.t("attributes.scoreboard.losses", count: 2)
      json.data data.values.map(&:losses)
      json.borderColor ChartsHelper::CHART_COLORS[:red]
      json.backgroundColor ChartsHelper::CHART_COLORS[:red]
    end
  end
end
