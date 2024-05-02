# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BucklerCredential do
  let(:credentials) do
    {
      'build_id' => '123',
      'cookies' => { 'foo' => 'bar' }
    }
  end

  it 'stores and fetch credentials' do
    described_class.store(credentials)
    expect(described_class.fetch).to eq(credentials)
  end

  it 'cleans the credentials' do
    described_class.store(credentials)
    described_class.clean
    expect(described_class.fetch).to be_nil
  end
end
