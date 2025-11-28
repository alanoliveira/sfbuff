class Fighter < ApplicationRecord
  validates :id, format: Patterns::SHORT_ID_REGEXP
end
