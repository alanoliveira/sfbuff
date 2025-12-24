module ModalsHelper
  def modal_turbo_frame_tag(**, &)
    turbo_frame_tag(modal_turbo_frame_name, **, &)
  end

  def modal_container(content = nil, data: {}, &)
    data = { controller: "modal #{data.delete(:controller)}", turbo_temporary: 1 }.merge(data)
    modal_turbo_frame_tag do
      content_tag(:div, content, class: "modal", tabindex: "-1", data:, &)
    end
  end

  def modal_close_button
    content_tag :button, t("buttons.close"), class: "btn btn-secondary", data: { bs_dismiss: "modal" }
  end

  def link_to_modal(*, data: {}, **, &)
    data[:turbo_frame] = modal_turbo_frame_name
    link_to(*, data:, **, &)
  end

  def modal_turbo_frame_name
    "modal"
  end
end
