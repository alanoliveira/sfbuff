module BucklerApi
  class NextData::ResponseParser
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
