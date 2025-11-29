module ModalsHelper
  def modal_turbo_frame_tag(&)
    turbo_frame_tag("modal", &)
  end

  def modal_container(content = nil, &)
    modal_turbo_frame_tag do
      content_tag(:div, content, class: "modal", tabindex: "-1", data: { controller: "modal", turbo_temporary: 1 }, &)
    end
  end

  def modal_close_button
    content_tag :button, t("buttons.close"), class: "btn btn-secondary", data: { bs_dismiss: "modal" }
  end

  def link_to_modal(*, data: {}, **, &)
    data[:turbo_frame] = "modal"
    link_to(*, data:, **, &)
  end
end
