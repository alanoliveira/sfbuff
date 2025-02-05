Rails.application.config.to_prepare do
  BucklerGateway.buckler_connection = BucklerApi::Connection.new do |config|
    base_url = ENV.fetch("BUCKLER_BASE_URL", "https://www.streetfighter.com")
    user_agent = ENV["BUCKLER_USER_AGENT"]
    email = ENV["BUCKLER_EMAIL"]
    password = ENV["BUCKLER_PASSWORD"]
    config.base_url = base_url
    config.user_agent = user_agent
    config.build_id_manager.strategies << BucklerApi::BuildIdStrategies::Faraday.new(base_url:, user_agent:)
    if ENV["BUCKLER_AUTH_COOKIES"].present?
      config.auth_cookies_manager.strategies << -> { ENV["BUCKLER_AUTH_COOKIES"] }
    else
      config.auth_cookies_manager.strategies << BucklerApi::AuthCookiesStrategies::Faraday.new(base_url:, user_agent:, email:, password:)
      config.auth_cookies_manager.strategies << BucklerApi::AuthCookiesStrategies::Selenium.new(base_url:, user_agent:, email:, password:)
    end

    config.adapter = BucklerApi::Adapters::FaradayAdapter.new do |conf|
      conf.response :logger, Rails.logger, { headers: false, bodies: false, errors: true }
    end
  end
end
