require "rails_helper"

RSpec.describe Buckler::ShortId do
  it { expect(described_class.new(123_456_789).to_s).to eq "123456789" }
  it { expect { described_class.new 12_345_67 }.to raise_error Buckler::InvalidShortId }
end
