class ApplicationLookupModel < ApplicationRecord
  LOOKUP_MODEL_STORE = ActiveSupport::Cache::MemoryStore.new(size: 8.kilobytes)

  self.abstract_class = true

  class << self
    include Enumerable

    def each(&)
      enum.values.each(&)
    end

    def [](val)
      id = val.to_i
      enum[id] || new(id:, name: "#{model_name.human}##{id}")
    end

    def enum
      LOOKUP_MODEL_STORE.fetch(name, expires_in: 30.minutes) do
        all.order(:id).to_a.index_by(&:id)
      end
    end
  end

  delegate :to_i, to: :id
end
