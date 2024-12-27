RSpec.shared_examples "a streamable job" do
  it "saves the result" do
    job.perform_now
    expect(Rails.cache.read("job/#{job.job_id}")).to be_present
  end

  context "when the job execution raises an error" do
    before { allow(job).to receive(:perform).and_raise(StandardError.new("boom")) }

    it "saves the result" do
      expect { job.perform_now }.to raise_error("boom") do |error|
        expect(Rails.cache.read("job/#{job.job_id}")).to match(
          html: a_string_including(ApplicationController.helpers.error_message(error))
        )
      end
    end
  end
end
