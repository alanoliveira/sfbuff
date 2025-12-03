module RescueFromBucklerApiHttpErrors
  extend ActiveSupport::Concern

  included do
    rescue_from BucklerApiClient::BucklerApiHttpError do |error|
      Rails.logger.error("buckler api client rose error: #{error.class.name}")
    end
  end
end
