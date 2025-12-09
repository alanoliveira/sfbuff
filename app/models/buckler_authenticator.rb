class BucklerAuthenticator
  attr_accessor :base_url, :user_agent, :email, :password

  def initialize(email: nil, password: nil, user_agent: nil, base_url: nil)
    @email = email || ENV["SFBUFF_BUCKLER_EMAIL"]
    @password = password || ENV["SFBUFF_BUCKLER_PASSWORD"]
    @user_agent = user_agent || ENV["SFBUFF_DEFAULT_USER_AGENT"]
    @base_url = base_url || ENV["SFBUFF_BUCKLER_BASE_URL"] || "https://www.streetfighter.com"
  end

  def login
    http_authentication || web_driver_authentication || raise("BucklerAuthenticator failed")
  end

  private

  def http_authentication
    HttpAuthenticator.new(email:, password:, user_agent:, base_url:).login
  rescue => error
    Rails.logger.info("BucklerAuthenticator#http_authentication has failed: #{error.class}")
    nil
  end

  def web_driver_authentication
    WebDriverAuthenticator.new(email:, password:, user_agent:, base_url:).login
  rescue => error
    Rails.logger.info("BucklerAuthenticator#web_driver_authentication has failed: #{error.class}")
    nil
  end
end
