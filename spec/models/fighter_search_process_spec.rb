require 'rails_helper'

RSpec.describe FighterSearchProcess do
  include ActionCable::TestHelper

  let(:fighter_search) { described_class.create(query: "Player") }

  context "when status is created" do
    before { fighter_search.update(status: "created") }

    describe "#subscribe!" do
      it { expect(fighter_search.subscribe!).to be_truthy }
      it { expect { fighter_search.subscribe! }.to change(fighter_search, :status).to("subscribed") }
      it { expect { fighter_search.subscribe! }.to have_enqueued_job(FighterSearchProcess::SearchJob) }
    end

    describe "#search_now!" do
      it { expect(fighter_search.search_now!).to be_falsey }
    end
  end

  context "when status is subscribed" do
    let(:buckler_gateway) { instance_double(FighterSearcher, search: []) }

    before do
      fighter_search.update(status: "subscribed")
      allow(FighterSearcher).to receive(:new).and_return(buckler_gateway)
    end

    describe "#subscribe!" do
      it { expect(fighter_search.subscribe!).to be_falsey }
    end

    describe "#search_now!" do
      it { expect(fighter_search.search_now!).to be_truthy }
      it { expect { fighter_search.search_now! }.to change(fighter_search, :status).to("finished") }

      it "broadcasts the response" do
        fighter_search.search_now!
        assert_broadcasts(fighter_search.to_gid_param, 1)
      end
    end
  end
end
