# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BucklerGateway do
  include ActiveJob::TestHelper

  subject(:buckler_gateway) { described_class.new }

  let(:api) { spy }

  before do
    allow(Buckler).to receive(:build_api).and_return(api)
  end

  RSpec.shared_examples 'regenerate credentials' do
    it 'clean the credentials' do
      buckler_gateway.hogehoge
      expect(BucklerCredential).to have_received(:clean)
    end

    it 'schedule a BucklerLoginJob' do
      assert_enqueued_with job: BucklerLoginJob do
        buckler_gateway.hogehoge
      end
    end
  end

  context 'when api throws an AccessDeniedError' do
    before do
      allow(api).to receive(:hogehoge).and_raise(Buckler::Client::AccessDeniedError)
      allow(BucklerCredential).to receive(:fetch)
      allow(BucklerCredential).to receive(:clean)
    end

    include_examples 'regenerate credentials'
  end

  context 'when api throws an NotFoundError' do
    before do
      allow(api).to receive(:hogehoge).and_raise(Buckler::Client::NotFoundError)
      allow(BucklerCredential).to receive(:fetch)
      allow(BucklerCredential).to receive(:clean)
    end

    include_examples 'regenerate credentials'
  end
end
