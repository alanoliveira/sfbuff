module Buckler
  module Api
    class AuthApi
      def initialize(connection:)
        @cookie_jar = HTTP::CookieJar.new
        @connection = connection.tap do |conf|
          conf.headers["dnt"] = "1"
          conf.headers["accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7"
          conf.headers["accept-language"] = "en-US,en;q=0.5"
          conf.headers["sec-ch-ua"] = '"Not?A_Brand";v="99", "Chromium";v="130"'
          conf.headers["sec-ch-ua-mobile"] = "?0"
          conf.headers["sec-ch-ua-platform"] = "Linux"
          conf.headers["sec-fetch-dest"] = "document"
          conf.headers["sec-fetch-mode"] = "navigate"
          conf.headers["sec-fetch-site"] = "none"
          conf.headers["sec-fetch-user"] = "?1"

          conf.response :raise_error
          conf.response :follow_redirects, { limit: 10 }
          conf.use :cookie_jar, { jar: @cookie_jar }
        end
      end

      def authenticate(email:, password:)
        conf = auth0_config
        login(
          conf["clientConfigurationBaseUrl"],
          username: email,
          password: password,
          client_id: conf["clientID"],
          redirect_uri: conf["callbackURL"],
          tenant: conf["auth0Tenant"],
          scope: conf["extraParams"]["scope"],
          state:  conf["extraParams"]["state"],
          response_type: conf["extraParams"]["response_type"],
          protocol: conf["extraParams"]["protocol"],
          ui_locales: conf["extraParams"]["ui_locales"],
          _csrf: conf["extraParams"]["_csrf"],
          _intstate: conf["extraParams"]["_intstate"],
          connection: "Username-Password-Authentication",
          popup_options: {},
          sso: true,
          show_sing_up: "0"
        ).then { |cb_config| callback(cb_config.delete(:action), cb_config) }

        @cookie_jar.cookies(@connection.url_prefix.to_s).map(&:to_s).join(";")
      end

      private

      def auth0_config
        response = @connection.get("/6/buckler/auth/loginep?redirect_url=/?status=login")
        Parser::Auth0ConfigParser.parse(response.body)
      end

      def login(url, body)
        uri = URI(url)
        uri.path = "/usernamepassword/login"
        response = @connection.post(uri) do |req|
          req.headers["Content-Type"] = "application/json"
          req.body = body.to_json
        end
        Parser::CallbackConfigParser.parse(response.body)
      end

      def callback(url, body)
        @connection.post(url) do |req|
          req.headers["Content-Type"] = "application/json"
          req.body = body.to_json
        end
      end
    end
  end
end
