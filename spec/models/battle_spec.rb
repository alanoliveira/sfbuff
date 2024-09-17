require "rails_helper"

RSpec.describe Battle, type: :model do
  it_behaves_like('a ResultScorable') do
    let(:scorable) { described_class.with_scores }
  end
end
