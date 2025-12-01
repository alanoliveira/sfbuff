require "active_support/core_ext/integer/time"

require_relative "production.rb"

Rails.application.configure do
  Rails.env = "production"
  config.consider_all_requests_local = true
  config.force_ssl = false
  config.assume_ssl = false
end
