module AdsenseEligible
  extend ActiveSupport::Concern

  included do
    before_action :set_ads_elegibility
  end

  class_methods do
    def allow_indexing(**options)
      skip_before_action :set_ads_elegibility, **options
    end
  end

  private

  def set_ads_elegibility
    @ads_elegibility = true
  end
end
