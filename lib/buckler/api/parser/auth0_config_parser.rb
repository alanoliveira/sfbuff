module Buckler
  module Api
    module Parser
      class Auth0ConfigParser
        def self.parse(body)
          new(body).parse
        end

        def initialize(body)
          @body = body
        end

        def parse
          JSON.parse(decoded_config)
        end

        private

        def decoded_config
          Base64.decode64(base64_config)
        end

        def base64_config
          @body[/atob\('([^']+)/, 1]
        end
      end
    end
  end
end
