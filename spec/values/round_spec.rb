require "rails_helper"

RSpec.describe Round do
  it { expect(described_class.new 0).to be_lose }
  it { expect(described_class.new 4).to be_draw }
  it { expect(described_class.new 1).to be_win }
end
