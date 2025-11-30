class AppSetting < ApplicationRecord
  def self.setting(key, encrypted: false)
    define_singleton_method(key) do
      where(key:).pick(:value)
    end

    define_singleton_method("#{key}=") do |value|
      find_or_initialize_by(key:) { it.encrypted = encrypted }.update(value:)
    end
  end
end
