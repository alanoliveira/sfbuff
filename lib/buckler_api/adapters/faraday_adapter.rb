class BucklerApi::Adapters::FaradayAdapter
  def initialize(&faraday_config)
    @faraday_config = faraday_config
  end

  def get(path, params: {}, headers: {})
    response = faraday.get(path, **params) do |req|
      req.headers = headers
    end

    BucklerApi::Response.new(status: response.status, body: response.body, headers: response.headers)
  end

  private

  def faraday
    Faraday.new do |conf|
      @faraday_config.call(conf) if @faraday_config
    end
  end
end
