require "rails_helper"

RSpec.shared_examples "a enum attribute" do
  let(:names) { {} }

  before { allow(described_class).to receive(:names).and_return(names) }

  it { expect(described_class).to be_an(Enumerable) }

  describe ".each" do
    let(:names) { { 1 => "one", 2 => "two" } }

    it "iterates over the named collection" do
      expect { |blk| described_class.each(&blk) }.to yield_successive_args(described_class.new(1), described_class.new(2))
    end
  end

  describe ".[<key>]" do
    subject(:returned_instance) { described_class[key] }

    context "when the key is a id" do
      let(:key) { 1 }

      it "returns an instance for the given id" do
        expect(returned_instance).to be_a_instance_of(described_class).and have_attributes(id: 1)
      end
    end

    context "when the key is a string present in the names hash" do
      let(:key) { "two" }
      let(:names) { { 2 => "two" } }

      it "returns an instance for the id corresponding to the given name" do
        expect(returned_instance).to be_a_instance_of(described_class).and have_attributes(id: 2)
      end
    end

    context "when the key is a string missing from the names hash" do
      let(:key) { "three" }
      let(:names) { {} }

      it { is_expected.to be_nil }
    end
  end

  describe "#to_s" do
    subject(:string) { described_class.new(1).to_s }

    context "with a registered id" do
      let(:names) { { 1 => "ok" } }

      it "returns registered string" do
        expect(string).to eq "ok"
      end
    end

    context "with a unregistered id" do
      let(:names) { {} }

      it "returns a fallback string for an invalid key" do
        expect(string).to end_with("#1")
      end
    end
  end

  describe "#eql?" do
    subject { described_class.new(1).eql? other }

    context "when `other` have the same id" do
      let(:other) { described_class.new(1) }

      it { is_expected.to be_truthy }
    end

    context "when `other` have a different id" do
      let(:other) { described_class.new(2) }

      it { is_expected.to be_falsey }
    end
  end

  describe "#hash" do
    subject(:hash) { described_class.new(1).hash }

    it "is the same for two instances with the same id" do
      expect(hash).to eq(described_class.new(1).hash)
    end

    it "is different for instances with different ids" do
      expect(hash).not_to eq(described_class.new(2).hash)
    end
  end
end
