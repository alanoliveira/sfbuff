module DailyResultsHelper
  def daily_results_chart_icon
    bs_icon("bar-chart-fill")
  end

  def link_to_daily_results_chart(filter_attributes, **html_options)
    link_to_modal daily_results_chart_icon, fighter_daily_results_chart_path(filter_attributes), **html_options
  end
end
