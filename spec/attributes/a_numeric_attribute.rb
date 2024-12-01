require "rails_helper"

RSpec.shared_examples "a numeric attribute" do
  describe "#to_s" do
    it "returns the value as string" do
      expect(described_class.new(123).to_s).to eq "123"
    end
  end

  describe "#+" do
    it "returns a new instance with the result" do
      instance1 = described_class.new(100)
      instance2 = described_class.new(150)
      expect(instance1 + instance2).to be_a_instance_of(described_class)
        .and eq 250
    end
  end
end
