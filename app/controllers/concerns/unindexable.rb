module Unindexable
  extend ActiveSupport::Concern

  included do
    before_action :set_unindexable
  end

  class_methods do
    def allow_indexing(**options)
      skip_before_action :set_unindexable, **options
    end
  end

  private

  def set_unindexable
    @unindexable = true
  end
end
