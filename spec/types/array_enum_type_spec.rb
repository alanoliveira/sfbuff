# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ArrayEnumType do
  let(:array_enum_type) { described_class.new(mapping, subtype) }
  let(:subtype) { spy }
  let(:mapping) do
    {
      one: 1,
      two: 2
    }
  end

  describe '#cast' do
    it 'cast a list of values' do
      expect(array_enum_type.cast([1, 2, 3])).to eq([:one, :two, 3])
    end
  end

  describe '#serialize' do
    before do
      allow(subtype).to receive(:serialize).with([1, 2, 3]).and_return('[1, 2, 3]')
    end

    it 'serialize a list of values' do
      expect(array_enum_type.serialize([:one, :two, 3])).to eq('[1, 2, 3]')
    end
  end

  describe '#deserialize' do
    before do
      allow(subtype).to receive(:deserialize).with('[1, 2, 3]').and_return([1, 2, 3])
    end

    it 'deserialize a list of values' do
      expect(array_enum_type.deserialize('[1, 2, 3]')).to eq([:one, :two, 3])
    end
  end
end
