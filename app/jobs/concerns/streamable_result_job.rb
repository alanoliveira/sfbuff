module StreamableResultJob
  extend ActiveSupport::Concern

  included do
    rescue_from(StandardError) do |error|
      locals = { error_class_name: error.class.name, message: error.message }
      Rails.cache.write("job/#{job_id}", { partial: "streamable_result_jobs/error", locals: })

      raise error
    end

    after_enqueue do
      Rails.cache.write("job/#{job_id}", nil)
    end
  end

  private

  def cache_result(**render)
    Rails.cache.write("job/#{job_id}", render)
  end
end
