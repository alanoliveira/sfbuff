module ToastsHelper
  def toasts_container_id
    "toasts"
  end

  def toasts_container(&)
    content_tag(:div, nil, class: "toast-container position-fixed bottom-0 end-0 p-3",
      id: toasts_container_id, data: { turbo_permanent: 1 }, &)
  end

  def toast_message(message, title: nil, kind: nil)
    content_tag :div, data: { controller: "toast" }, class: [ "toast", kind.try { "text-bg-#{it}" } ] do
      if title
        render "helpers/toasts/titled_toast", message:, title:, kind:
      else
        render "helpers/toasts/simple_toast", message:, kind:
      end
    end
  end
end
