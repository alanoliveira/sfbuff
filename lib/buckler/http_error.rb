module Buckler
  class HttpError < StandardError
    def initialize(response)
      @response = response
      super("the server responded with status #{response.status}")
    end
  end
end
