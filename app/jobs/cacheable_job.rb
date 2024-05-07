# frozen_string_literal: true

module CacheableJob
  class Error < StandardError; end
  class JobCacheNotFound < Error; end

  class << self
    attr_accessor :cache_provider
  end

  def cache(status, data = nil)
    CacheableJob.cache_provider
                .with_options(expires_in: 5.minutes)
                .write(job_id, { status:, data: })
  end

  def self.included(base)
    base.extend(ClassMethods)

    base.after_enqueue do
      cache(:waiting)
    end
  end

  module ClassMethods
    def find_job_status(job_id)
      CacheableJob.cache_provider.read(job_id)
    end

    def find_job_status!(job_id)
      find_job_status(job_id) || raise(JobCacheNotFound)
    end
  end
end
