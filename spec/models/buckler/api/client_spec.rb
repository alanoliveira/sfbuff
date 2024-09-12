require 'rails_helper'

RSpec.describe Buckler::Api::Client do
  let(:connection) do
    Buckler::Api::Connection.build do |conf|
      conf.adapter :test, stubs
    end
  end

  let(:stubs) { Faraday::Adapter::Test::Stubs.new }

  describe '.under_maintenance?' do
    subject(:under_maintenance) { described_class.under_maintenance?(connection) }

    it do
      stubs.head('/6/buckler/fighterslist/friend') { [ 503, {}, nil ] }
      expect(under_maintenance).to be_truthy
    end

    it do
      stubs.head('/6/buckler/fighterslist/friend') { [ 403, {}, nil ] }
      expect(under_maintenance).to be_falsey
    end

    it do
      stubs.head('/6/buckler/fighterslist/friend') { [ 200, {}, nil ] }
      expect(under_maintenance).to be_falsey
    end
  end

  describe '.remote_build_id' do
    subject(:remote_build_id) { described_class.remote_build_id(connection) }

    before do
      stubs.get('/6/buckler') do
        [ 200, { 'Content-Type': 'text/html' }, %(<script>{"buildId":"123456"}</script>) ]
      end
    end

    it { is_expected.to eq '123456' }
  end

  describe '#request' do
    subject(:response) { client.request(action_path:, params:) }

    let(:client) { described_class.new(cookies: 'foo=bar;', build_id: 'ABC123', connection:) }
    let(:action_path) { 'foo' }
    let(:params) { { 'key' => 'val' } }

    before do
      full_path = client.connection.build_url("/6/buckler/_next/data/#{client.build_id}/en/#{action_path}", params)
      stubs.get(full_path, 'Cookie' => client.cookies) do
        [ 200, { 'Content-Type' => 'application/json' }, { pageProps: 'ok' }.to_json ]
      end
    end

    it { is_expected.to eq 'ok' }
  end
end
