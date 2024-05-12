# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Buckler::Client do
  let(:client) do
    described_class.new(
      credentials,
      { base_url: 'http://www.example.com' }
    )
  end
  let(:credentials) { Buckler::Credentials.new(build_id: '123', cookies: { foo: 'bar' }) }

  shared_examples 'a buckler request' do
    it 'uses the credentials' do
      stub_request(:any, /.*/).to_return(status: 200, body: '{}')
      subject
      expect(WebMock).to have_requested(:get, Regexp.new("/6/buckler/_next/data/#{credentials.build_id}/en/"))
        .with(headers: { cookie: credentials.cookies.to_query })
    end

    context 'when api returns a unauthorized response status' do
      it 'raises an AccessDeniedError' do
        stub_request(:any, /.*/).to_return(status: 401)
        expect { subject }.to raise_error(Buckler::Client::AccessDeniedError)
      end
    end

    context 'when api returns some error' do
      it 'raises an RequestError' do
        stub_request(:any, /.*/).to_return(status: 500)
        expect { subject }.to raise_error(Buckler::Client::RequestError)
      end
    end
  end

  describe '#battlelog' do
    subject { client.battlelog(123_456_789) }

    it_behaves_like 'a buckler request'
  end

  describe '#fighterslist' do
    subject { client.fighterslist(fighter_id: 'player1') }

    it_behaves_like 'a buckler request'
  end
end
