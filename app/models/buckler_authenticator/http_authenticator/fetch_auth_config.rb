class BucklerAuthenticator::HttpAuthenticator::FetchAuthConfig
  def initialize(connection)
    @connection = connection
  end

  def call
    response = @connection.get("/6/buckler/auth/loginep?redirect_url=/?status=login")
    ResponseParser.parse(response.body)
  end

  class ResponseParser
    def self.parse(body)
      new(body).parse
    end

    def initialize(body)
      @body = body
    end

    def parse
      JSON.parse(decoded_config)
    end

    private

    def decoded_config
      Base64.decode64(base64_config)
    end

    def base64_config
      @body[/atob\('([^']+)/, 1]
    end
  end
end
