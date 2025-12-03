require 'rails_helper'

RSpec.describe SessionsCleanupJob do
  before do
    described_class.deletable_threshold = 2.weeks
    create(:session, last_active_at: Time.zone.now)
    create(:session, last_active_at: 1.week.ago)
    create(:session, last_active_at: 2.weeks.ago)
    create(:session, last_active_at: 3.weeks.ago)
  end

  it "clean old sessions" do
    described_class.perform_now
    expect(Session.all).to have_attributes(count: 2).and all(have_attributes(last_active_at: a_value > 2.weeks.ago))
  end
end
