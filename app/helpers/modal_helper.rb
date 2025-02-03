module ModalHelper
  def link_to_modal(*, data: {}, **, &)
    link_to(*, data: { turbo_frame: "modal", **data }, **, &)
  end

  def modal_container(data: {}, **, &)
    turbo_frame_tag "modal" do
      tag.div class: "modal", tabindex: -1,
        data: { controller: "modal", turbo_temporary: true, **data }, **, &
    end
  end

  def modal_dismiss_button(value = nil, data: {}, **, &)
    value ||= t("buttons.close")
    tag.button value, data: { bs_dismiss: "modal", **data }, **, &
  end
end
