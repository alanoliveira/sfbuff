class BucklerApi::Response
  attr_accessor :status, :headers, :body

  def initialize(status:, headers:, body:)
    @status = status
    @headers = headers
    @body = body
  end

  def success?
    status == 200
  end

  def path_not_found?
    status == 404 && content_type != "application/json"
  end

  def forbidden?
    status == 403
  end

  def under_maintenance?
    status == 503
  end

  def rate_limit_exceeded?
    status == 405 && headers["x-amzn-waf-action"]
  end

  def page_props
    json_body.fetch("pageProps")
  end

  def json_body
    JSON.parse(body)
  end

  private

  def content_type
    headers["content-type"]
  end
end
