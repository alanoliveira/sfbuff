require "rails_helper"

RSpec.shared_context "with timezone cookie set" do |timezone: "UTC"|
  before { cookies["timezone"] = timezone }
end
