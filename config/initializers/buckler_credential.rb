# frozen_string_literal: true

Rails.application.config.to_prepare do
  BucklerCredential.store(Buckler::Credentials.new) if BucklerCredential.read.nil?
end
