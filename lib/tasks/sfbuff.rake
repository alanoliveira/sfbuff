namespace :sfbuff do
  desc "prepare sfbuff to run"
  task prepare: :environment do
    unless BucklerClient.any?
      BucklerClient.create!
      BucklerLoginJob.perform_now
    end
  end
end
