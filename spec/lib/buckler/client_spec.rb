# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Buckler::Client do
  let(:client) do
    described_class.new(
      Buckler::Credentials.new(build_id: '123', cookies: {}),
      { base_url: 'http://www.example.com' }
    )
  end

  shared_examples 'a buckler request' do
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
