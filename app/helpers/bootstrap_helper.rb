module BootstrapHelper
  def bs_icon(icon, **opts)
    tag.i nil, class: [ "bi", "bi-#{icon}", opts.delete(:class) ], **opts
  end
end
