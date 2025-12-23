class Session < ApplicationRecord
  class_attribute :activity_refresh_rate, instance_writer: false, default: 1.hour
  class_attribute :inactive_threshold, instance_writer: false, default: 2.hour

  has_many :synchronization_requests, dependent: :delete_all

  scope :active, -> { where(last_active_at: inactive_threshold.ago..) }

  before_create { self.last_active_at ||= Time.zone.now }

  def active?
    last_active_at.before?(inactive_threshold.ago)
  end

  def refreshable?
    last_active_at.before?(activity_refresh_rate.ago)
  end

  def self.start!(user_agent:, ip_address:)
    create! user_agent: user_agent, ip_address: ip_address
  end

  def resume(user_agent:, ip_address:)
    if refreshable?
      update! user_agent: user_agent, ip_address: ip_address, last_active_at: Time.zone.now
    end
  end
end
