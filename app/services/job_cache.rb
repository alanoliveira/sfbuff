# frozen_string_literal: true

class JobCache
  class Error < StandardError; end
  class NotFound < Error; end

  class << self
    attr_accessor :cache_provider

    def save(job_id, status, data = nil)
      JobCache.cache_provider
              .with_options(expires_in: 5.minutes)
              .write(job_id, { status:, data: })
    end

    def find_job(job_id)
      cache_provider.read(job_id)
    end

    def find_job!(job_id)
      find_job(job_id) || raise(NotFound)
    end
  end
end
