require 'rails_helper'

RSpec.shared_examples "a BadGatewayHandleable job" do
  context "when a BadGateway is thrown" do |args|
    it "retries" do
      expect { bad_gateway_job.perform_now }.to have_enqueued_job.with(*bad_gateway_job.arguments)
    end
  end
end
