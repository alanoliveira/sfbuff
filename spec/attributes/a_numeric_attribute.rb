require "rails_helper"

RSpec.shared_examples "a numeric attribute" do
  describe "#+" do
    it "returns a new instance with the result" do
      instance1 = described_class.new(100)
      instance2 = described_class.new(150)
      expect(instance1 + instance2).to be_a_instance_of(described_class)
        .and eq 250
    end
  end
end
