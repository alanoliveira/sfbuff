class Buckler::Api::Login
  attr_reader :email, :password, :driver

  def self.run(email:, password:, driver: default_driver)
    new(email:, password:, driver:).execute
  end


  def self.default_driver
    user_agent = Rails.configuration.buckler["user_agent"]

    options = Selenium::WebDriver::Options.chrome(
      args: [
        "--headless",
        "--user-agent=#{user_agent}",
        "--no-sandbox",
        "--disable-gpu",
        "--disable-dev-shm-usage",
        "--blink-settings=imagesEnabled=false"
      ]
    )

    Selenium::WebDriver.for(:chrome, options:)
  end


  def initialize(email:, password:, driver: self.class.default_driver)
    @email = email
    @password = password
    @driver = driver
  end

  def execute
    age_check
    visit_login
    sleep 1
    execute_login
    sleep 3
    visit_support_page

    driver.manage.all_cookies.map do |c|
      c.values_at(:name, :value).join("=")
    end.join(";")
  ensure
    driver.quit
  end

  private

  def visit_login
    driver.navigate.to buckler_path("/6/buckler/auth/loginep")
    Selenium::WebDriver::Wait.new(timeout: 5).until do
      driver.find_elements(name: "email").any?(&:displayed?)
    end
  end

  def execute_login
    driver.find_element(name: "email").send_keys(email)
    driver.find_element(name: "password").send_keys(password)
    driver.find_element(name: "submit").click
  end

  def visit_support_page
    driver.navigate.to buckler_path("/6/buckler/support/en-us/")
  end

  def fetch_build_id
    driver.page_source[/"buildId":"([^"]*)"/, 1]
  end

  def age_check
    driver.execute_cdp("Network.setCookie", domain: cid_domain, name: "agecheck", value: "true")
  end

  def buckler_path(path)
    URI.join(Rails.configuration.buckler["base_url"], path)
  end

  def cid_domain
    Rails.configuration.buckler["cid_domain"]
  end
end
