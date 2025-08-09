module BadGatewayHandleable
  extend ActiveSupport::Concern

  included { retry_on BucklerApi::Errors::BadGateway, attempts: 2 }
end
