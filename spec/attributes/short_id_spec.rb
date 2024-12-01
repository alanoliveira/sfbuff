require "rails_helper"

RSpec.describe ShortId do
  subject(:short_id) { described_class.new(123_456_789) }

  describe ".new" do
    it "returns a new instance" do
       expect(described_class.new(123_456_789)).to be_a_instance_of described_class
     end

    context "with a invalid short id" do
      it { expect { described_class.new(1) }.to raise_error ArgumentError }
    end
  end

  describe "#to_i" do
    it "returns the short_id as an integer" do
      expect(short_id.to_i).to eq 123_456_789
    end
  end

  describe "#to_s" do
    it "returns the short_id as a string" do
      expect(short_id.to_s).to eq "123456789"
    end
  end
end
