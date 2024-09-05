module BootstrapHelper
  def bs_progress_bar_stacked(progresses: [])
    content_tag :div, class: "progress-stacked" do
      progresses.each { concat bar_for_progress_bar_stacked(**_1) }
    end
  end

  private

  def bar_for_progress_bar_stacked(percent:, bg_class: "bg-info", **)
    content = "#{percent.to_i}%"
    content_tag :div, class: "progress", role: "progressbar", style: "width: #{percent}%", ** do
      content_tag :div, content, title: content, class: [ "progress-bar", bg_class ]
    end
  end
end
