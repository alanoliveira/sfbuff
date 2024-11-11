module Buckler
  class UnderMaintenance < HttpError; end
  class RateLimitExceeded < HttpError; end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
