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

    def default_client
      @default_client ||= Client.new
    end

    private

    def respond_to_missing?(...)
      default_client.respond_to?(...) || super
    end

    def method_missing(method_name, ...)
      default_client.send(method_name, ...)
    end
  end
end
