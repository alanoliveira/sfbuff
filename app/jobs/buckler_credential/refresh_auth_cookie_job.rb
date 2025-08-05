class BucklerCredential::RefreshAuthCookieJob < ApplicationJob
  queue_as :urgent

  def perform(buckler_credential)
    new_auth_cookie = try_login_with_faraday ||
      try_login_with_selenium ||
      BucklerApi::Configuration.auth_cookie

    buckler_credential.set_auth_cookie! new_auth_cookie
  end

  private

  def try_login_with_faraday
    BucklerApi::LoginStrategies::Faraday.login
  rescue e
    Rails.logger.error("failed to login with faraday: #{e}")
    nil
  end

  def try_login_with_selenium
    BucklerApi::LoginStrategies::Selenium.login
  rescue e
    Rails.logger.error("failed to login with selenium: #{e}")
    nil
  end
end
