require 'rails_helper'

RSpec.describe PlayerSynchronizeJob, type: :job do
  subject(:job) { described_class.perform_later(player_synchronize_process) }

  let(:player) { create(:player) }
  let(:player_synchronize_process) { create(:player_synchronize_process, short_id: player.short_id) }

  before do
    allow(player_synchronize_process).to receive(:execute)
  end

  it "executes the player_synchronize_process" do
    job.perform_now
    expect(player_synchronize_process).to have_received(:execute)
  end
end
