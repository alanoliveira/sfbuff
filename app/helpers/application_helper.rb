module ApplicationHelper
  def alert(message = nil, kind: :info, **opts, &)
    content_tag(:div, message, **opts, role: "alert",
      class: [ "alert", "alert-#{kind}", opts[:class] ], &)
  end

  def nav_link(name, url, active_class: "active", **opts)
    active = active_class if current_page?(url)
    link_to name, url, class: [ opts.delete(:class), active ], **opts
  end

  def time_ago(time)
    content_tag :span, t("datetime.time_ago", time: time_ago_in_words(time)),
                title: l(time, format: :short)
  end

  def search_form(**, &block)
    form_with url: buckler_player_search_path, method: :get, role: "search", ** do |f|
      content_tag :div, class: "input-group" do
        concat (f.text_field :q, value: params[:q], placeholder: t("helpers.search_form.placeholder"),
          class: "form-control", type: "search", required: true, minlength: 4)

        yield f if block_given?
      end
    end
  end

  def spinner(**opts)
    content_tag :div, class: [ "spinner-border", opts.delete(:class) ], role: "status" do
      content_tag :span, t("aria.loading"), class: "visually-hidden"
    end
  end

  def channel_error_alert(error:)
    alert "#{error.class}: #{error}", kind: :danger
  end

  def mr_lp(mr:, lp:)
    content_tag :span do
      if mr.positive?
        "#{mr} #{t("attributes.master_rating")}"
      elsif lp.positive?
        "#{lp} #{t("attributes.league_point")}"
      end
    end
  end

  def signed_number(number)
    css_class = case number
    when ..-1 then "text-danger"
    when 1.. then "text-success"
    else ""
    end
    content_tag(:span, format("%+d", number), class: css_class)
  end

  def score_bar(score, **)
    bs_progress_bar_stacked(progresses: [
      { percent: score.win_percent, bg_class: "bg-success", aria: { value_now: score.win_percent } },
      { percent: score.draw_percent, bg_class: "bg-warning", aria: { value_now: score.draw_percent } },
      { percent: score.lose_percent, bg_class: "bg-danger", aria: { value_now: score.lose_percent } }
    ], **)
  end

  def color_mode_select
    render "helpers/color_mode_select", options: {
      "light" => "brightness-high-fill",
      "dark" => "moon-fill",
      "auto" => "circle-half"
    }
  end
end
