require "rails_helper"

RSpec.describe Buckler::Api::Parser::Auth0ConfigParser do
  subject(:auth_config) { described_class.new(html) }

  let(:config_b64) { Base64.encode64({ "result" => "OK" }.to_json) }

  let(:body) do
    <<-HTML
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0" />
      </head>
      <body>
      <script src="https://hogehoge.fugafuga/lock.min.js"></script>
      <script>
        function getParam(name, url) {
          console.log('Hello world')
        }
        // Decode utf8 characters properly
        var config = JSON.parse(decodeURIComponent(escape(window.atob('#{config_b64}'))));
        config.extraParams = config.extraParams || {};
        var connection = config.connection;
      </script>
        <h1>Test</h1>
      </body>
      </html>
    HTML
  end

  describe ".parse" do
    it "extract auth0 config json" do
      expect(described_class.parse(body)) .to eq("result" => "OK")
    end
  end
end
