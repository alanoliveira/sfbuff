class BucklerClient < ApplicationRecord
  class Error < StandardError; end
  class CredentialExpired < Error; end

  include ActiveSupport::Rescuable

  enum :status, [ "ok", "expired" ]

  rescue_from Faraday::ForbiddenError do |e|
    if with_lock { expired! unless expired? }
      # TODO: run the login using a one off dyno instead a job
      BucklerLoginJob.perform_later
    end

    raise e
  end

  def api
    raise CredentialExpired if expired?

    @api ||= Buckler::Api::Client.new(cookies:, build_id:, connection:)
  end

  private

  def connection
    rescue_handler = ->(e) { rescue_with_handler(e) || raise }
    Buckler::Api::Connection.build(rescue_handler:)
  end
end
