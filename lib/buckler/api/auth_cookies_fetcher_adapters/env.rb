module Buckler
  module Api
    module AuthCookiesFetcherAdapters
      module Env
        def self.call
          ENV["BUCKLER_AUTH_COOKIES"] unless ENV.fetch("BUCKLER_AUTH_COOKIES").empty?
        rescue => e
          Buckler.configuration.logger.info("Atempt to fetch cookies using ENV failed #{e}")
          nil
        end
      end
    end
  end
end
