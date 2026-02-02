class AppSetting < ApplicationRecord
  def self.setting(key, encrypted: false)
    define_singleton_method(key) do
      where(key:).pick(:value)
    end

    define_singleton_method("#{key}=") do |value|
      find_or_initialize_by(key:) { it.encrypted = encrypted }.update(value:)
    end
  end

  setting :buckler_build_id
  setting :buckler_auth_cookie, encrypted: true
  setting :footer_sns_accounts
  setting :general_alerts
  setting :extra_meta_tags
  setting :google_ads_tag
end
