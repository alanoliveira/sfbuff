module StreamableResultJob
  extend ActiveSupport::Concern

  included do
    rescue_from(StandardError) do |error|
      raw = ApplicationController.renderer.render_to_string(
        template: "turbo_streams/error",
        locals: { error: })
      Rails.cache.write("job/#{job_id}", { html: raw })

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
