class BucklerApi::BuildIdStrategies::Faraday
  attr_accessor :base_url, :user_agent

  def initialize(base_url:, user_agent:)
    @base_url, @user_agent = base_url, user_agent
  end

  def call
    response = build_connection.get("/6/buckler", cache_buster: Time.now.to_i)
    ResponseParser.parse(response.body).fetch("buildId")
  rescue
  end

  private

  def build_connection
    ::Faraday.new(base_url) do |conf|
      conf.headers = { "user-agent" => user_agent }
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
