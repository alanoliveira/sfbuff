module ApplicationHelper
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
    content_tag :div, "#{error.class}: #{error}"
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
end
