module BucklerApi::BuildIdStrategies::Faraday
  extend self

  def call
    response = build_connection.get("/6/buckler", cache_buster: Time.now.to_i)
    ResponseParser.parse(response.body).fetch("buildId")
  rescue => e
    BucklerApi.logger.info("Atempt to fetch cookies using HTTP failed #{e}")
    nil
  end

  private

  def build_connection
    ::Faraday.new(BucklerApi::BASE_URL) do |conf|
      conf.headers = { "user-agent" => BucklerApi::USER_AGENT }
      conf.response :raise_error
    end
  end

  class ResponseParser
    def self.parse(body)
      new(body).parse
    end

    def initialize(body)
      @document = Nokogiri::HTML.parse(body)
    end

    def parse
      JSON.parse(next_data_script_node.text)
    end

    private

    def next_data_script_node
      @document.xpath("//script[@id='__NEXT_DATA__']")
    end
  end
end
