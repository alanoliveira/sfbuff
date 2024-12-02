class BucklerApi::AuthCookiesStrategies::Selenium
  def self.build_chrome_driver
    options = ::Selenium::WebDriver::Options.chrome(
      args: [
        "--headless",
        "--user-agent=#{BucklerApi::USER_AGENT}",
        "--no-sandbox",
        "--disable-gpu",
        "--disable-dev-shm-usage",
        "--blink-settings=imagesEnabled=false"
      ]
    )
    ::Selenium::WebDriver.for(:chrome, options:)
  end

  attr_accessor :email, :password

  def initialize(email:, password:)
    @email = email
    @password = password
  end

  def call
    visit_login

    if current_uri.host[/^cid.*/]
      age_check
      visit_login
    end

    ::Selenium::WebDriver::Wait.new(timeout: 5).until do
      driver.find_elements(name: "email").any?(&:displayed?)
    end

    execute_login

    ::Selenium::WebDriver::Wait.new(timeout: 5).until do
      current_uri.path[%r{.*/information/all/1$}]
    end

    driver.manage.all_cookies.map do |c|
      c.values_at(:name, :value).join("=")
    end.join(";")
  rescue => e
    BucklerApi.logger.info("Atempt to fetch cookies using Selenium failed #{e}")
    nil
  ensure
    driver.quit
  end

  def driver
    @driver ||= self.class.build_chrome_driver
  end

  private

  def visit_login
    driver.navigate.to "https://www.streetfighter.com/6/buckler/auth/loginep?redirect_url=/information/all/1"
  end

  def execute_login
    driver.find_element(name: "email").send_keys(email)
    driver.find_element(name: "password").send_keys(password)
    driver.find_element(name: "submit").click
  end

  def age_check
    driver.execute_cdp("Network.setCookie", domain: current_uri.host, name: "agecheck", value: "true")
  end

  def current_uri
    URI(driver.current_url)
  end
end
