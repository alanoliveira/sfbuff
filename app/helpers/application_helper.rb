module ApplicationHelper
  def page_title(title)
    content_for(:title) { [ title, "SFBUFF" ].join(" - ") }
  end

  def alert(message = nil, kind: :info, **opts, &)
    opts[:class] = Array(opts[:class]) | [ "alert", "alert-#{kind}" ]
    content_tag(:div, message, role: "alert", **opts, &)
  end

  def nav_item(name, url, active_class: "active", params: nil, **opts)
    opts[:class] = Array(opts[:class]) | [ active_class ] if current_page?(url)
    if params.present?
      uri = URI(url)
      uri.query = [ uri.query, params.to_query ].compact_blank.join("&")
      url = uri.to_s
    end
    link_to name, url, method: :get, **opts
  end

  def time_ago(time, **opts)
    opts[:title] = l(time, format: :short)
    content_tag :span, t("datetime.time_ago", time: time_ago_in_words(time)), **opts
  end

  def spinner
    content_tag :div, class: "spinner-border", role: "status" do
      content_tag :span, "#{t("aria.texts.loading")}...", class: "visually-hidden"
    end
  end

  def error_alert(error)
    key = error.class.name.underscore
    key = "generic" unless I18n.exists?(key, scope: "errors")
    alert(t(key, scope: "errors"), kind: "danger")
  end

  def mr_lp(mr:, lp:)
    content_tag :span do
      if mr.positive?
        "#{mr} #{t("attributes.master_rating.short")}"
      elsif lp.positive?
        "#{lp} #{t("attributes.league_point.short")}"
      end
    end
  end

  def no_data_alert
    alert(t("helpers.no_data_alert.message"), kind: "warning")
  end

  def signed_number(number)
    css_class = case number
    when ..-1 then "text-danger"
    when 1.. then "text-success"
    else ""
    end
    content_tag(:span, class: css_class) do
      number.zero? ? "0" : format("%+d", number)
    end
  end

  def option_any
    content_tag :option, t("helpers.option_any.label"), value: ""
  end

  def color_mode_select
    render "helpers/color_mode_select", options: {
      "light" => "brightness-high-fill",
      "dark" => "moon-fill",
      "auto" => "circle-half"
    }
  end

  def locale_select
    render "helpers/locale_select", selected: I18n.locale, options: {
      "English" => :en,
      "Português" => :"pt-BR",
      "日本語" => :ja
    }
  end
end
