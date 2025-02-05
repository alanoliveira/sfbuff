class BucklerApi::AuthCookiesStrategies::Faraday
  attr_accessor :base_url, :user_agent, :email, :password

  def initialize(base_url:, user_agent:, email:, password:)
    @base_url = base_url
    @user_agent = user_agent
    @email = email
    @password = password
    @cookie_jar = HTTP::CookieJar.new
  end

  def call
    connection = build_connection
    auth_config = FetchAuthConfig.new(connection).call
    callback_config = ExecuteLogin.new(connection, auth_config["clientConfigurationBaseUrl"], {
      username: email,
      password: password,
      client_id: auth_config["clientID"],
      redirect_uri: auth_config["callbackURL"],
      tenant: auth_config["auth0Tenant"],
      scope: auth_config["extraParams"]["scope"],
      state:  auth_config["extraParams"]["state"],
      response_type: auth_config["extraParams"]["response_type"],
      protocol: auth_config["extraParams"]["protocol"],
      ui_locales: auth_config["extraParams"]["ui_locales"],
      _csrf: auth_config["extraParams"]["_csrf"],
      _intstate: auth_config["extraParams"]["_intstate"],
      connection: "Username-Password-Authentication",
      popup_options: {},
      sso: true,
      show_sing_up: "0"
    }).call
    ExecuteCallback.new(connection, callback_config.delete(:action), callback_config).call

    @cookie_jar.cookies(connection.url_prefix.to_s).map(&:to_s).join(";")
  rescue
  end

  private

  def build_connection
    ::Faraday.new(base_url) do |conf|
      conf.headers = { "user-agent" => user_agent }
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
      conf.response :raise_error
      conf.response :follow_redirects, { limit: 10 }
      conf.use :cookie_jar, { jar: @cookie_jar }
    end
  end
end
