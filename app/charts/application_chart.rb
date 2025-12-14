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

  delegate_missing_to :@view_context

  def render_in(view_context)
    @view_context = view_context
    chartjs_data_value = render partial: partial_path, formats: :json, locals: { this: self }
    tag.div data: { controller: "chartjs", chartjs_data_value: } do
      concat tag.button bs_icon("download"), class: "btn", data: { chartjs_target: "downloadButton" }
      concat tag.canvas data: { chartjs_target: "canvas" }
    end
  end

  def partial_path
    "charts/#{self.class.name.underscore}"
  end
end
