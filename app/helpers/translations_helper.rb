module TranslationsHelper
  def human_enum_name(enum)
    t("enums.#{enum.class.name.underscore}.#{enum.name}")
  end

  def human_error_message(error_name)
    t("alerts.errors.#{error_name.underscore}", default: t("alerts.errors.generic"))
  end
end
