require "rails_helper"

RSpec.describe Buckler::Api::Parser::CallbackConfigParser do
  subject(:auth_config) { described_class.new(html) }

  let(:body) do
    <<-HTML
      <form method="post" name="hiddenform" action="https://auth.cid.hogehoge.fugafuga/login/callback">
          <input type="hidden" name="wa" value="wa value">
          <input type="hidden"
                 name="wresult"
                 value="wresult value">
          <input type="hidden" name="wctx" value="wctx value">
          <noscript>
              <p>
                  Script is disabled. Click Submit to continue.
              </p><input type="submit" value="Submit">
          </noscript>
      </form>
    HTML
  end

  describe ".parse" do
    it "extract redirect auth config data" do
      expect(described_class.parse(body)).to eq(
        action: "https://auth.cid.hogehoge.fugafuga/login/callback",
        wa: "wa value",
        wresult: "wresult value",
        wctx: "wctx value"
      )
    end
  end
end
