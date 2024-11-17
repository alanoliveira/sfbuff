module Buckler
  module Api
    module BuildIdFetcherAdapters
      class Http
        attr_reader :connection_builder

        def initialize(connection_builder: nil)
          @connection_builder = connection_builder || ConnectionBuilder
        end

        def call
          Api::SiteApi.new(connection: connection_builder.build).fetch("buildId")
        rescue => e
          Buckler.configuration.logger.info("Atempt to fetch cookies using HTTP failed #{e}")
          nil
        end
      end
    end
  end
end
