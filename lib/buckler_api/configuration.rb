module BucklerApi::Configuration
  DEFAULT_BASE_URL = "https://www.streetfighter.com".freeze

  @logger = Logger.new(nil)
  @base_url = ENV["BUCKLER_BASE_URL"] || DEFAULT_BASE_URL
  @user_agent = ENV["BUCKLER_USER_AGENT"]
  @email = ENV["BUCKLER_EMAIL"]
  @password = ENV["BUCKLER_PASSWORD"]
  @auth_cookie = ENV["BUCKLER_AUTH_COOKIE"]
  @build_id = ENV["BUCKLER_BUILD_ID"]

  class << self
    attr_accessor :logger, :base_url, :user_agent, :email, :password,
      :build_id, :auth_cookie
  end
end
