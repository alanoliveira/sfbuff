module BucklerApi
  class NextData
    attr_reader :connection

    def initialize(connection: nil)
      @connection = connection || Connection.new
    end

    def build_id
      data["buildId"]
    end

    private

    def data
      @data ||= begin
        response = connection.get("/6/buckler")
        ResponseParser.new(response.body).parse
      end
    end
  end
end
