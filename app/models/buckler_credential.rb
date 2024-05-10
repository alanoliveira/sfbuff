# frozen_string_literal: true

class BucklerCredential
  class Error < StandardError; end
  class CredentialdNotReady < Error; end

  class << self
    def read
      Model.pick
    end

    def fetch
      read || raise(CredentialdNotReady)
    end

    def store(credentials)
      Model.transaction do
        clean
        Model.create(credentials:)
      end
    end

    def clean
      Model.delete_all
    end
  end

  class Model < ApplicationRecord
    self.table_name = 'buckler_credentials'
  end
end
