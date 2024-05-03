# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RoundType do
  let(:round_type) { described_class.new }

  it 'cast a integer to round' do
    expect(round_type.cast(1)).to be_a(Round).and have_attributes(raw: 1)
  end

  it 'cast a string to round' do
    expect(round_type.cast('1')).to be_a(Round).and have_attributes(raw: 1)
  end

  it 'serialize a round' do
    expect(round_type.serialize(Round.new(1))).to eq(1)
  end
end
