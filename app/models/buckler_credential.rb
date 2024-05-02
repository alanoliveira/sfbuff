# frozen_string_literal: true

class BucklerCredential
  class << self
    def fetch
      Model.pick
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
