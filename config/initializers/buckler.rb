Rails.application.config.to_prepare do
  Buckler.configure do |conf|
    conf.base_url = ENV.fetch("BUCKLER_BASE_URL") { "https://www.streetfighter.com" }
    conf.user_agent = ENV.fetch("BUCKLER_USER_AGENT")
    conf.email = ENV.fetch("BUCKLER_EMAIL")
    conf.password = ENV.fetch("BUCKLER_PASSWORD")
    conf.logger = Rails.logger.tagged("BucklerApi")
  end
end
