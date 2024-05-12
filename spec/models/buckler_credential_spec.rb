# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BucklerCredential do
  let(:credentials) do
    {
      'build_id' => '123',
      'cookies' => { 'foo' => 'bar' }
    }
  end

  describe '.store' do
    it 'store the credentials' do
      expect { described_class.store(credentials) }
        .to change(BucklerCredential::Model, :first)
        .to(an_object_having_attributes(credentials:))
    end
  end

  describe '.clean' do
    before { BucklerCredential::Model.create(credentials:) }

    it 'clean the credentials' do
      expect { described_class.clean }
        .to change(BucklerCredential::Model, :first)
        .to(nil)
    end
  end

  describe '.read' do
    context 'when there is credentials' do
      before { described_class.store(credentials) }

      it 'returns the stored credentials' do
        expect(described_class.read).to eq(credentials)
      end
    end

    context 'when there is no credentials' do
      before { described_class.clean }

      it 'returns the stored credentials' do
        expect(described_class.read).to be_nil
      end
    end
  end

  describe '.fetch' do
    context 'when there is credentials' do
      before { described_class.store(credentials) }

      it 'returns the stored credentials' do
        expect(described_class.fetch).to eq(credentials)
      end
    end

    context 'when there is no credentials' do
      before { described_class.clean }

      it 'returns the stored credentials' do
        expect { described_class.fetch }.to raise_error(BucklerCredential::CredentialdNotReady)
      end
    end
  end
end
