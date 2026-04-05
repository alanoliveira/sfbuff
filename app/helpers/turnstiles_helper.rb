module TurnstilesHelper
  def turnstile_form
    form_with url: human_verification_path, data: { controller: "turnstile-form", turnstile_form_sitekey_value: HumanVerification.cf_turnstile_site_key } do |f|
      content_tag :div, nil, data: { turnstile_form_target: "widget" }
    end
  end
end
