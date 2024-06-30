# frozen_string_literal: true

class Player < ApplicationRecord
  def self.sync_threshold
    Rails.configuration.sfbuff['data_sync_threshold'].seconds.ago
  end

  def synchronized?
    synchronized_at.present? && synchronized_at > Player.sync_threshold
  end

  def battles
    Battle.pov.where(player: { player_sid: sid })
  end
end
