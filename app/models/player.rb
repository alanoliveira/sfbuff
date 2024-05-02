# frozen_string_literal: true

class Player < ApplicationRecord
  def synchronized?
    synchronized_at.present? && synchronized_at > 10.minutes.ago
  end
end
