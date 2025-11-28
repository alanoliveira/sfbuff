module BucklerApiGateway::Mappers
  class BaseMapper
    attr_reader :data

    delegate :[], :dig, :as_json, to: :data

    def initialize(data)
      @data = data
    end
  end
end
