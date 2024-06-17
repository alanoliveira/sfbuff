# frozen_string_literal: true

module BucklerHelper
  def character(val)
    val = Buckler::CHARACTERS.key(val) if val.is_a? Integer
    key = "buckler.characters.#{val}"

    t(key) if val.present? && I18n.exists?(key)
  end

  def control_type(val, format: :short)
    val = Buckler::CONTROL_TYPES.key(val) if val.is_a? Integer
    key = "buckler.control_types.#{val}"
    return unless val.present? && I18n.exists?(key)

    format == :short ? val.to_s[0].upcase : t(key).titlecase
  end

  def battle_type(val)
    val = Buckler::BATTLE_TYPES.key(val) if val.is_a? Integer
    key = "buckler.battle_types.#{val}"

    t(key).titlecase if val.present? && I18n.exists?(key)
  end

  def round_result(val)
    val = Buckler::ROUNDS.key(val) if val.is_a? Integer

    val.to_s if val.present?
  end
end
