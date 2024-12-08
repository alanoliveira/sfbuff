RSpec.shared_examples "a streamable job" do
  it "saves the result" do
    job.perform_now
    expect(Rails.cache.read("job/#{job.job_id}")).to be_present
  end

  context "when the job execution raises an error" do
    before { allow(job).to receive(:perform).and_raise(StandardError.new("boom")) }

    it "saves the result" do
      expect { job.perform_now }.to raise_error("boom")
      expect(Rails.cache.read("job/#{job.job_id}")).to match(
        locals:  { error_class_name: "StandardError", message: "boom" },
        partial: "streamable_result_jobs/error",
      )
    end
  end
end
