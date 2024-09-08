module BootstrapHelper
  def bs_progress_bar_stacked(progresses: [])
    content_tag :div, class: "progress-stacked" do
      progresses.each { concat bar_for_progress_bar_stacked(**_1) }
    end
  end

  def bs_icon(icon, **opts)
    content_tag(:i, nil, class: [ "bi", "bi-#{icon}", opts.delete(:class) ], **opts)
  end

  private

  def bar_for_progress_bar_stacked(percent:, bg_class: "bg-info", **)
    content = "%0.2f%%" % percent
    content_tag :div, class: "progress", role: "progressbar", style: "width: #{percent}%", ** do
      content_tag :div, content, title: content, class: [ "progress-bar", bg_class ]
    end
  end
end
