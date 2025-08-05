Rails.application.config.to_prepare do
  BucklerApi::Configuration.base_url = ENV["BUCKLER_BASE_URL"] if ENV.key?("BUCKLER_BASE_URL")
  BucklerApi::Configuration.user_agent = ENV["BUCKLER_USER_AGENT"] if ENV.key?("BUCKLER_USER_AGENT")
  BucklerApi::Configuration.email = ENV["BUCKLER_EMAIL"] if ENV.key?("BUCKLER_EMAIL")
  BucklerApi::Configuration.password = ENV["BUCKLER_PASSWORD"] if ENV.key?("BUCKLER_PASSWORD")
  BucklerApi::Configuration.build_id = ENV["BUCKLER_BUILD_ID"] if ENV.key?("BUCKLER_BUILD_ID")
  BucklerApi::Configuration.auth_cookie = ENV["BUCKLER_AUTH_COOKIE"] if ENV.key?("BUCKLER_AUTH_COOKIE")
  BucklerApi::Configuration.logger = Rails.logger
end
