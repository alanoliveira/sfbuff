# frozen_string_literal: true

module Buckler
  class Login
    CONFIG_ATTRS = %i[base_url cid_domain user_agent email password].freeze

    attr_accessor :driver, *CONFIG_ATTRS

    def initialize(config = {})
      CONFIG_ATTRS.each do |attr|
        public_send("#{attr}=", config[attr] || Buckler.configuration.send(attr))
      end
      self.driver = config[:driver] || default_driver
    end

    def execute
      age_check
      visit_login
      sleep 1
      execute_login
      sleep 3
      visit_support_page
      create_credentials
    ensure
      driver.quit
    end

    private

    def default_driver
      options = Selenium::WebDriver::Options.chrome(
        args: ['--headless', "--user-agent=#{user_agent}", '--no-sandbox']
      )

      Selenium::WebDriver.for(:chrome, options:)
    end

    def visit_login
      driver.navigate.to("#{base_url}/6/buckler/auth/loginep")
      Selenium::WebDriver::Wait.new(timeout: 5).until do
        driver.find_elements(name: 'email').any?(&:displayed?)
      end
    end

    def execute_login
      driver.find_element(name: 'email').send_keys(email)
      driver.find_element(name: 'password').send_keys(password)
      driver.find_element(name: 'submit').click
    end

    def visit_support_page
      driver.navigate.to("#{base_url}/6/buckler/support/en-us/")
    end

    def create_credentials
      Buckler::Credentials.new(
        cookies: fetch_cookies,
        build_id: fetch_build_id
      )
    end

    def fetch_cookies
      driver.manage.all_cookies.to_h { |c| [c[:name], c[:value]] }
    end

    def fetch_build_id
      driver.page_source[/"buildId":"([^"]*)"/, 1]
    end

    def age_check
      driver.execute_cdp('Network.setCookie', domain: cid_domain, name: 'agecheck', value: 'true')
    end
  end
end
