module Buckler
  module Api
    module BuildIdFetcherAdapters
      module Env
        def self.call
          ENV["BUCKLER_BUILD_ID"] unless ENV.fetch("BUCKLER_BUILD_ID").empty?
        rescue => e
          Buckler.configuration.logger.info("Atempt to fetch cookies using ENV failed #{e}")
          nil
        end
      end
    end
  end
end
