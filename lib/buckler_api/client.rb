module BucklerApi
  class Client
    attr_reader :connection, :build_id, :auth_cookie

    def initialize(connection: nil, build_id: nil, auth_cookie: nil)
      @connection = connection || Connection.new
      @build_id = build_id || Configuration.build_id
      @auth_cookie = auth_cookie || Configuration.auth_cookie
    end

    def fighter
      Fighter.new(self)
    end

    def get(path, params = {})
      response = connection.get(path_prefix + path, params:, headers:)
      ResponseErrorHandler.handle!(response) unless response.success?

      response.body.fetch("pageProps")
    end

    private

    def headers
      { "Cookie" => auth_cookie }
    end

    def path_prefix
      "/6/buckler/_next/data/#{build_id}/en/"
    end
  end
end
