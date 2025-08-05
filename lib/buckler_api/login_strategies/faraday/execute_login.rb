class BucklerApi::LoginStrategies::Faraday::ExecuteLogin
  def initialize(connection, url, params)
    @connection = connection
    @url = url
    @params = params
  end

  def call
    uri = URI(@url)
    uri.path = "/usernamepassword/login"
    response = @connection.post(uri) do |req|
      req.headers["Content-Type"] = "application/json"
      req.body = @params.to_json
    end
    ResponseParser.parse(response.body)
  end

  class ResponseParser
    def self.parse(body)
      new(body).parse
    end

    def initialize(body)
      @document = Nokogiri.HTML(body)
    end

    def parse
      { action:, wa:, wresult:, wctx: }
    end

    private

    def action
      form.attr("action").value
    end

    def wa
      extract_attr("wa")
    end

    def wresult
      extract_attr("wresult")
    end

    def wctx
      extract_attr("wctx")
    end

    def extract_attr(name)
      form.xpath("//input[@name='#{name}']").attr("value").value
    end

    def form
      @document.xpath("//form")
    end
  end
end
