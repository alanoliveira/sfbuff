# frozen_string_literal: true

Rails.application.config.to_prepare do
  CacheableJob.cache_provider = if Rails.env.production?
                                  ActiveSupport::Cache::MemCacheStore.new(ENV.fetch('MEMCACHED_HOST'))
                                else
                                  ActiveSupport::Cache::MemoryStore.new
                                end
end
