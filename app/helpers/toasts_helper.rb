module ToastsHelper
  def simple_toast(content = nil, type = "primary", data: {}, **opts, &)
    opts[:class] = Array(opts[:class]) | [ "toast", "align-items-center", "text-bg-#{type}", "border-0" ]
    data[:controller] = "toast #{data[:controller]}".strip
    opts[:role] = "alert"
    tag.div class:, data:, **opts do
      render "helpers/simple_toast" do
        concat(content || capture(&))
      end
    end
  end
end
