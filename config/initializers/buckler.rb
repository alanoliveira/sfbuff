# frozen_string_literal: true

require 'buckler'

Buckler.configure do |config|
  Rails.application.config_for(:buckler).each do |key, value|
    config.public_send("#{key}=", value)
  end
end
