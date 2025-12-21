require 'rails_helper'

RSpec.describe Fighter::Synchronization::StallZombiesJob do
  let(:zombie_threshold) { 3.minutes }

  before do
    freeze_time
    described_class.zombie_threshold = zombie_threshold
    create(:fighter_synchronization, :success, created_at: (zombie_threshold + 1).ago)
    create(:fighter_synchronization, :failure, created_at: (zombie_threshold + 1).ago)
    create(:fighter_synchronization, :created, created_at: (zombie_threshold + 1).ago)
    create(:fighter_synchronization, :processing, created_at: (zombie_threshold + 1).ago)
    create(:fighter_synchronization, :created, created_at: zombie_threshold.ago)
    create(:fighter_synchronization, :processing, created_at: (zombie_threshold - 1).ago)
  end

  it do
    described_class.perform_now
    expect(Fighter::Synchronization.stall).to have_attributes(count: 3).and all(
      have_attributes(created_at: a_value <= zombie_threshold.ago)
    )
  end
end
