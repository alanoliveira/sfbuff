module Adsenses
  extend ActiveSupport::Concern

  class_methods do
    def ads_eligible(**options)
      before_action :set_ads_elegibility
    end
  end

  private

  def set_ads_elegibility
    @ads_elegibility = true
  end
end
