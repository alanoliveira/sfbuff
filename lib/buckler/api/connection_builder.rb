module Buckler
  module Api
    class ConnectionBuilder
      def self.build
        Faraday.new Buckler.configuration.base_url do |conf|
          conf.response :logger, Buckler.configuration.logger, { headers: false, bodies: false, errors: true }
          conf.headers["user-agent"] = Buckler.configuration.user_agent
          conf.headers["priority"] = "u=0,i"
          conf.headers["dnt"] = "1"
          conf.headers["accept-language"] = "en-US,en;q=0.5"
          conf.headers["sec-ch-ua"] = '"Not?A_Brand";v="99", "Chromium";v="130"'
          conf.headers["sec-ch-ua-mobile"] = "?0"
          conf.headers["sec-ch-ua-platform"] = "Linux"
          conf.headers["sec-fetch-dest"] = "document"
          conf.headers["sec-fetch-mode"] = "navigate"
          conf.headers["sec-fetch-site"] = "none"
          conf.headers["sec-fetch-user"] = "?1"
          conf.headers["accept"] = "text/html,application/xhtml+xml,application/xml;" \
            "q=0.9,image/avif,image/webp,image/apng,*/*;" \
            "q=0.8,application/signed-exchange;v=b3;q=0.7"
          yield conf if block_given?
        end
      end
    end
  end
end
