module ApplicationHelper
  def page_title(title = nil)
    content_for :title, [ title, "SFBUFF" ].join(" - ")
  end

  def too_many_requests_toast_alert
    turbo_stream_toast t("alerts.too_many_requests"), kind: "danger"
  end
end
