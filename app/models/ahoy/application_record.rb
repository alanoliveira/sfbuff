class Ahoy::ApplicationRecord < ApplicationRecord
  self.abstract_class = true

  connects_to database: { writing: :ahoy, reading: :ahoy }
end
