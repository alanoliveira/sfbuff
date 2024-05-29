# frozen_string_literal: true

Rails.application.config.to_prepare do
  JobCache.cache_provider =
    if Rails.env.test?
      ActiveSupport::Cache::MemoryStore.new
    else
      ActiveSupport::Cache::MemCacheStore.new(
        ENV.fetch('MEMCACHED_HOST', nil),
        {
          username: ENV.fetch('MEMCACHED_USERNAME', nil),
          password: ENV.fetch('MEMCACHED_PASSWORD', nil)
        }
      )
    end
end
