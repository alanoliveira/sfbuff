module ChartsHelper
  CHART_COLORS = {
    red: "rgb(255, 99, 132)",
    orange: "rgb(255, 159, 64)",
    yellow: "rgb(255, 205, 86)",
    green: "rgb(75, 192, 192)",
    blue: "rgb(54, 162, 235)",
    purple: "rgb(153, 102, 255)",
    grey: "rgb(201, 203, 207)"
  }

  def render_chart(chart_data)
    tag.div data: { controller: "chartjs", chartjs_data_value: chart_data } do
      concat tag.button icon("download"), class: "btn", data: { chartjs_target: "downloadButton" }, aria: { label: t("buttons.download") }
      concat tag.canvas data: { chartjs_target: "canvas" }
    end
  end
end
