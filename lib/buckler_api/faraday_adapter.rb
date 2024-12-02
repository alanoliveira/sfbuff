module BucklerApi::FaradayAdapter
  extend self

  def get(path, params: {}, headers: {})
    response = Faraday.get(path, **params) do |req|
      req.headers = headers
    end

    BucklerApi::Response.new(status: response.status, body: response.body, headers: response.headers)
  end
end
