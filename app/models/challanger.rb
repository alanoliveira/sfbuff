# frozen_string_literal: true

class Challanger < ApplicationRecord
  singleton_class.define_method(:rounds) { Buckler::ROUNDS.invert }

  enum :character, Buckler::CHARACTERS.invert, instance_methods: false, validate: { allow_nil: true }
  enum :control_type, Buckler::CONTROL_TYPES.invert, instance_methods: false, validate: { allow_nil: true }
  enum :side, { p1: 1, p2: 2 }, instance_methods: false
  attribute(:rounds) { |subtype| ArrayEnumType.new(Buckler::ROUNDS.invert, subtype) }

  belongs_to :battle
end
