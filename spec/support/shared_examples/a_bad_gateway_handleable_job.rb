require 'rails_helper'

RSpec.shared_examples "a BucklerServerErrorHandleable job" do
  context "when a BucklerServerError is thrown" do |args|
    it "retries" do
      expect { bad_gateway_job.perform_now }.to have_enqueued_job.with(*bad_gateway_job.arguments)
    end
  end
end
