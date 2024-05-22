# frozen_string_literal: true

class Player < ApplicationRecord
  def synchronized?
    synchronized_at.present? && synchronized_at > sync_threshold
  end

  def battles
    Battle.joins(:challengers).where(challengers: { player_sid: sid })
  end

  private

  def sync_threshold
    Rails.configuration.sfbuff['data_sync_threshold'].seconds.ago
  end
end
