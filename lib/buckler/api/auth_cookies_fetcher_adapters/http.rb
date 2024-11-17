module Buckler
  module Api
    module AuthCookiesFetcherAdapters
      class Http
        attr_reader :connection_builder, :email, :password

        def initialize(connection_builder: nil, email: nil, password: nil)
          @connection_builder = connection_builder || ConnectionBuilder
          @email = email || Buckler.configuration.email
          @password = password || Buckler.configuration.password
        end

        def call
          Api::AuthApi.new(connection: connection_builder.build)
            .authenticate(email:, password:)
        rescue => e
          Buckler.configuration.logger.info("Atempt to fetch cookies using HTTP failed #{e}")
          nil
        end
      end
    end
  end
end
