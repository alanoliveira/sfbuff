# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BucklerLoginJob do
  let(:buckler_login) { spy }
  let(:credentials) { anything }

  before do
    allow(buckler_login).to receive(:execute).and_return(credentials)
    allow(Buckler::Login).to receive(:new).and_return(buckler_login)
  end

  context 'when BucklerCredential is not set' do
    before do
      allow(BucklerCredential).to receive(:read).and_return(nil)
      allow(BucklerCredential).to receive(:store)
    end

    it 'do try do login' do
      described_class.perform_now
      expect(buckler_login).to have_received(:execute)
    end

    it 'do not update the credentials' do
      described_class.perform_now
      expect(BucklerCredential).to have_received(:store).with(credentials)
    end
  end

  context 'when BucklerCredential is already set' do
    before do
      allow(BucklerCredential).to receive(:read).and_return(credentials)
      allow(BucklerCredential).to receive(:store)
    end

    it 'do not try do login' do
      described_class.perform_now
      expect(buckler_login).not_to have_received(:execute)
    end

    it 'do not update the credentials' do
      described_class.perform_now
      expect(BucklerCredential).not_to have_received(:store)
    end
  end

  context 'when BucklerCredential is already set and force: true is used' do
    before do
      allow(BucklerCredential).to receive(:read).and_return(credentials)
      allow(BucklerCredential).to receive(:store)
    end

    it 'do try do login' do
      described_class.perform_now(force: true)
      expect(buckler_login).to have_received(:execute)
    end

    it 'do not update the credentials' do
      described_class.perform_now(force: true)
      expect(BucklerCredential).to have_received(:store).with(credentials)
    end
  end
end
