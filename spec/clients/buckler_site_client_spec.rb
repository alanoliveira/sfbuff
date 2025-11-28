require "rails_helper"

RSpec.describe BucklerSiteClient do
  let(:buckler_site_client) { described_class.new }

  def stub_request(method, path)
    uri = URI.parse(described_class.base_url).merge(path)
    super(method, uri)
      .with(headers: { "User-Agent" => described_class.user_agent })
  end

  describe "#next_data" do
    let(:response) { <<-HTML }
      <!DOCTYPE html>
      <html lang="en">
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <title></title>
          <link href="css/style.css" rel="stylesheet">
        </head>
        <body>
          <script id="__NEXT_DATA__" type="application/json">
          {"response": "ok"}
          </script>
        </body>
      </html>
    HTML

    before do
        stub_request(:get, "/6/buckler").to_return(body: response)
    end

    it { expect(buckler_site_client.next_data).to eq({ "response" => "ok" }) }
  end
end
