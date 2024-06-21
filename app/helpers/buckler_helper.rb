# frozen_string_literal: true

module BucklerHelper
  def character(val)
    val = Buckler::CHARACTERS.key(val) if val.is_a? Integer
    key = "buckler.characters.#{val}"

    t(key) if val.present? && I18n.exists?(key)
  end

  def control_type(key, format: :short)
    key = Buckler::CONTROL_TYPES.key(key) if key.is_a? Integer
    scope = %w[buckler control_types]
    return unless key.present? && I18n.exists?(key, scope:)

    scope << 'short' if format == :short

    t(key, scope:)
  end

  def battle_type(val)
    val = Buckler::BATTLE_TYPES.key(val) if val.is_a? Integer
    key = "buckler.battle_types.#{val}"

    t(key) if val.present? && I18n.exists?(key)
  end

  def round_result(val)
    val = Buckler::ROUNDS.key(val) if val.is_a? Integer

    val.to_s if val.present?
  end
end
