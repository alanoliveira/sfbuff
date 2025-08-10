module BadGatewayHandleable
  extend ActiveSupport::Concern

  included { retry_on BucklerApi::Errors::BadGateway, attempts: 3, wait: 6.seconds }
end
