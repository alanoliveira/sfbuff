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
end

json.data do
  json.labels this.labels
  json.datasets do
    json.child! do
      json.label Score.human_attribute_name(:wins)
      json.data this.wins_data
      json.borderColor ApplicationChart::CHART_COLORS[:green]
      json.backgroundColor ApplicationChart::CHART_COLORS[:green]
    end
    json.child! do
      json.label Score.human_attribute_name(:draws)
      json.data this.draws_data
      json.borderColor ApplicationChart::CHART_COLORS[:yellow]
      json.backgroundColor ApplicationChart::CHART_COLORS[:yellow]
    end
    json.child! do
      json.label Score.human_attribute_name(:losses)
      json.data this.losses_data
      json.borderColor ApplicationChart::CHART_COLORS[:red]
      json.backgroundColor ApplicationChart::CHART_COLORS[:red]
    end
  end
end
