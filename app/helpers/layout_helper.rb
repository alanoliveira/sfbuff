module LayoutHelper
  def general_alert_item(alert_item)
    return if alert_item["locale"] && alert_item["locale"] != I18n.locale.name
    alert alert_item["content"].html_safe, alert_item["type"], dismissible: alert_item["dismissible"]
  end

  def footer_sns_account_item(sns_item)
    content_tag :li, class: "nav-item col-6 col-lg-auto" do
      link_to bs_icon(sns_item["icon"]), sns_item["url"], target: "_blank", class: "nav-link px-2 fs-5"
    end
  end
end
