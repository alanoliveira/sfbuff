require 'rails_helper'

RSpec.describe ProfileSearchProcess::Clearable do
  before do
    create_list(:profile_search_process, 5, created_at: 1.day.ago)
    create_list(:profile_search_process, 3)
  end

  describe ".clear_in_batches" do
    it "remove clearable items" do
      expect { ProfileSearchProcess.clear_in_batches }.to change { ProfileSearchProcess.clearable.count }.from(5).to(0)
    end

    it "keep not clearable items" do
      expect { ProfileSearchProcess.clear_in_batches }.not_to change { ProfileSearchProcess.clearable.invert_where.count }
    end
  end
end
