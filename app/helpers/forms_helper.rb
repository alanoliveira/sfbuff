module FormsHelper
  def auto_submit_form_with(data: {}, **attributes)
    data[:controller] = "auto-submit #{data[:controller]}".strip
    form_with data: data, **attributes do |form|
      yield form if block_given?
    end
  end

  def form_reset_button
    link_to t("buttons.reset"), false, data: { turbo_prefetch: false }, class: "btn btn-secondary"
  end

  def any_option_label
    t("forms.any")
  end

  def character_options_for_select
    Character.all.map { [ human_enum_name(it), it.id ] }
  end

  def input_type_options_for_select
    InputType.all.map { [ human_enum_name(it), it.id ] }
  end

  def battle_type_options_for_select
    BattleType.all.map { [ human_enum_name(it), it.id ] }
  end
end
