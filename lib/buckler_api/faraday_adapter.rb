module BucklerApi::FaradayAdapter
  extend self

  def get(path, params: {}, headers: {})
    response = faraday.get(path, **params) do |req|
      req.headers = headers
    end

    BucklerApi::Response.new(status: response.status, body: response.body, headers: response.headers)
  end

  private

  def faraday
    Faraday.new do |conf|
      conf.response :logger, BucklerApi.logger, { headers: false, bodies: false, errors: true }
    end
  end
end
