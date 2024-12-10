class ApplicationChart
  CHART_COLORS = {
    red: "rgb(255, 99, 132)",
    orange: "rgb(255, 159, 64)",
    yellow: "rgb(255, 205, 86)",
    green: "rgb(75, 192, 192)",
    blue: "rgb(54, 162, 235)",
    purple: "rgb(153, 102, 255)",
    grey: "rgb(201, 203, 207)"
  }

  def render_in(context)
    context.content_tag :div, class: "card card-body" do
      context.content_tag :canvas, nil, data: {
        controller: "chartjs",
        chartjs_type_value: chart_type,
        chartjs_options_value: options,
        chartjs_data_value: data
      }
    end
  end
end
