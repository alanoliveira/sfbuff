module BucklerServerErrorHandleable
  extend ActiveSupport::Concern

  included { retry_on BucklerApi::Errors::BucklerServerError, attempts: 3, wait: 6.seconds }
end
