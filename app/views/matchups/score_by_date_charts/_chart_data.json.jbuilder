data = data.to_h { |score, date| [ date, score ] }

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
      json.label Result.human_attribute_name("result/win", count: 2)
      json.data data.values.map(&:win)
      json.borderColor ChartsHelper::CHART_COLORS[:green]
      json.backgroundColor ChartsHelper::CHART_COLORS[:green]
    end
    json.child! do
      json.label Result.human_attribute_name("result/draw", count: 2)
      json.data data.values.map(&:draw)
      json.borderColor ChartsHelper::CHART_COLORS[:yellow]
      json.backgroundColor ChartsHelper::CHART_COLORS[:yellow]
    end
    json.child! do
      json.label Result.human_attribute_name("result/lose", count: 2)
      json.data data.values.map(&:lose)
      json.borderColor ChartsHelper::CHART_COLORS[:red]
      json.backgroundColor ChartsHelper::CHART_COLORS[:red]
    end
  end
end
