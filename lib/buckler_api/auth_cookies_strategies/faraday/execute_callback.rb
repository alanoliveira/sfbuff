class BucklerApi::AuthCookiesStrategies::Faraday::ExecuteCallback
  def initialize(connection, url, params)
    @connection = connection
    @url = url
    @params = params
  end

  def call
    @connection.post(@url) do |req|
      req.headers["Content-Type"] = "application/json"
      req.body = @body.to_json
    end
  end
end
