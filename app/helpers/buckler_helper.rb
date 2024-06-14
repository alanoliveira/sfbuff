# frozen_string_literal: true

module BucklerHelper
  def character(val)
    val = Buckler::CHARACTERS.key(val) if val.is_a? Integer

    t("buckler.characters.#{val}")
  end

  def control_type(val, format: :short)
    val = Buckler::CONTROL_TYPES.key(val) if val.is_a? Integer

    format == :short ? val.to_s[0].upcase : t("buckler.control_types.#{val}").titlecase
  end

  def battle_type(val)
    val = Buckler::BATTLE_TYPES.key(val) if val.is_a? Integer

    t("buckler.battle_types.#{val}").titlecase
  end
end
