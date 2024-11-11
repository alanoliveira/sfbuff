require 'rails_helper'

RSpec.describe Buckler::Parser::NextDataParser do
  let(:body) do
    <<-HTML
      <!DOCTYPE html>
      <html lang="en">
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <title></title>
          <link href="css/style.css" rel="stylesheet">
        </head>
        <body>
          <script id="__NEXT_DATA__" type="application/json">{"props": "OK"}</script>
        </body>
      </html>
    HTML
  end


  describe ".parse" do
    it "extract __NEXT_DATA__ json" do
      expect(described_class.parse(body)) .to eq({ "props" => "OK" })
    end
  end
end
