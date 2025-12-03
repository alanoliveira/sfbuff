module BucklerApiGateway::Mappers
  class BaseMapper
    include ActiveModel::API

    attr_reader :data

    delegate :[], :dig, :as_json, to: :data

    def initialize(data)
      @data = data
    end
  end
end
