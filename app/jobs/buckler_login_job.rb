class BucklerLoginJob < ApplicationJob
  queue_as :default

  def perform
    cookies = Buckler::Api::Login.run(
      email: ENV.fetch("BUCKLER_EMAIL"),
      password: ENV.fetch("BUCKLER_PASSWORD")
    )

    BucklerClient.take.update(cookies:)
  end
end
