# frozen_string_literal: true

class BucklerLoginJob < ApplicationJob
  limits_concurrency to: 1, key: 'buckler_login'

  queue_as :default

  def perform
    return if BucklerCredential.fetch.present?

    credentials = Buckler::Login.new.execute
    BucklerCredential.store(credentials)
  end
end
