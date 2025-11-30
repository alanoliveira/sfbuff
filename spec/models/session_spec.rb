require 'rails_helper'

RSpec.describe Session do
  before do
    described_class.activity_refresh_rate = 1.hour
    described_class.inactive_threshold = 2.hour
  end

  context "when the session last_active_at is > activity_refresh_rate" do
    let(:session) { create(:session, last_active_at: 59.minutes.ago) }

    it { expect(session).not_to be_refreshable }
    it { expect { session.resume(user_agent: "foobar", ip_address: "111.111.111.111") }.not_to change(session, :last_active_at) }
  end

  context "when the session last_active_at is < activity_refresh_rate" do
    let(:session) { create(:session, last_active_at: 1.hour.ago) }

    it { expect(session).to be_refreshable }
    it { expect { session.resume(user_agent: "foobar", ip_address: "111.111.111.111") }.to change(session, :last_active_at) }
  end

  context "when the session last_active_at is > inactive_threshold" do
    let(:session) { create(:session, last_active_at: 119.minutes.ago) }

    it { expect(session).not_to be_active }
  end

  context "when the session last_active_at is < inactive_threshold" do
    let(:session) { create(:session, last_active_at: 120.minutes.ago) }

    it { expect(session).to be_active }
  end
end
