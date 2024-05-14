# frozen_string_literal: true

Rails.application.config.to_prepare do
  next unless Rails.env.production?

  BucklerCredential.store(Buckler::Credentials.new) if BucklerCredential.read.nil?
end
