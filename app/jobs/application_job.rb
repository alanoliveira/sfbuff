class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError

  # workaround for https://github.com/rails/rails/issues/52183
  def self.rescue_from(*klasses, with: nil, &block)
    with = block if block_given?
    super(*klasses) do |e|
      I18n.with_locale(locale) do
        instance_exec e, &with
      end
    end
  end
end
