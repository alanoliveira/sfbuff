# frozen_string_literal: true

Rails.application.config.to_prepare do
  JobCache.cache_provider =
    if Rails.env.production?
      ActiveSupport::Cache::MemCacheStore.new(
        ENV.fetch('MEMCACHED_HOST'),
        {
          username: ENV.fetch('MEMCACHED_USERNAME', nil),
          password: ENV.fetch('MEMCACHED_PASSWORD', nil)
        }
      )
    else
      ActiveSupport::Cache::MemoryStore.new
    end
end
