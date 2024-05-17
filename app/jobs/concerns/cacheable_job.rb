# frozen_string_literal: true

module CacheableJob
  extend ActiveSupport::Concern

  included do
    after_enqueue do
      cache(:waiting)
    end

    around_perform do |_job, block|
      block.call
    rescue StandardError => e
      cache(:error, { class: e.class.name, message: e.message })
      raise e
    end
  end

  class_methods do
    def find_job_status!(job_id)
      JobCache.find_job!(job_id)
    end
  end

  private

  def cache(status, data = nil)
    JobCache.save(job_id, status, data)
  end
end
