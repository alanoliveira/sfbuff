module ToastsHelper
  def simple_toast(content = nil, type = "primary", bs_options: {}, &)
    content ||= capture(&)
    render "helpers/simple_toast", content:, type:, bs_options:
  end
end
