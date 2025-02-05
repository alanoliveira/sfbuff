class BucklerApi::AuthCookiesStrategies::Selenium
  attr_accessor :base_url, :user_agent, :email, :password

  def initialize(base_url:, user_agent:, email:, password:)
    @base_url = base_url
    @user_agent = user_agent
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
  rescue
  ensure
    driver.quit
  end

  def driver
    @driver ||= build_chrome_driver
  end

  private

  def build_chrome_driver
    options = ::Selenium::WebDriver::Options.chrome(
      args: [
        "--headless",
        "--user-agent=#{user_agent}",
        "--no-sandbox",
        "--disable-gpu",
        "--disable-dev-shm-usage",
        "--blink-settings=imagesEnabled=false"
      ]
    )
    ::Selenium::WebDriver.for(:chrome, options:)
  end

  def visit_login
    driver.navigate.to "#{base_url}/6/buckler/auth/loginep?redirect_url=/information/all/1"
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
