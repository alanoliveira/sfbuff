module ProfileSearchProcess::Clearable
  extend ActiveSupport::Concern

  included do
    scope :clearable, -> { where(created_at: ..1.day.ago) }
  end

  class_methods do
    def clear_in_batches(sleep_between_batches: 0, batch_size: 500)
      clearable.in_batches(of: batch_size) do |batch|
        deleted = batch.delete_all
        sleep sleep_between_batches if deleted == batch_size && sleep_between_batches.positive?
      end
    end
  end
end
