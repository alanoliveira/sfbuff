namespace :buckler do
  desc "perform login on buckler"
  task login: :environment do
    atempt = (atempt || 0) + 1
    logger.info("Running login (atempt #{atempt})")
    BucklerLoginJob.perform_now
    logger.info("Completed login")
  rescue StandardError => e
    logger.info("Error on login (atempt #{atempt})")
    sleep 5
    retry if atempt < 3
  end

  def logger
    @logger ||= Rails.logger.tagged("buckler-task")
  end
end
