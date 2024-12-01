require "rails_helper"
require_relative "a_enum_attribute"

RSpec.describe Round do
  it_behaves_like "a enum attribute"

  it { expect(described_class["L"]).to be_lose }
  it { expect(described_class["D"]).to be_draw }
  it { expect(described_class["V"]).to be_win }
end
