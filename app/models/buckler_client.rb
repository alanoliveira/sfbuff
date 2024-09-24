class BucklerClient < ApplicationRecord
  class Error < StandardError; end
  class CredentialExpired < Error; end
  class UnderMaintenance < Error; end
  class BuildIdChanged < Error; end
  class RateLimitExceeded < Error; end

  include ActiveSupport::Rescuable

  enum :status, [ "ok", "expired" ]
  attribute :build_id, default: -> { Buckler::Api::Client.remote_build_id }

  rescue_from Faraday::ClientError, with: :client_error_handler!
  rescue_from Faraday::ServerError, with: :server_error_handler!

  def api
    raise CredentialExpired if expired?

    @api ||= Buckler::Api::Client.new(cookies:, build_id:, connection:, locale:)
  end

  private

  def locale
    case I18n.locale
    when :ja then "ja-jp"
    when :'pt-BR' then "pt-br"
    else "en"
    end
  end

  def connection
    rescue_handler = ->(e) { rescue_with_handler(e) || raise }
    Buckler::Api::Connection.build(rescue_handler:)
  end

  def client_error_handler!(e)
    resource_not_found_handler!(e) if e.is_a? Faraday::ResourceNotFound
    forbidden_error_handler!(e) if e.is_a? Faraday::ForbiddenError
    raise RateLimitExceeded if e.response[:status] == 405 && e.response.dig(:headers, "x-amzn-waf-action")

    raise e
  end

  def server_error_handler!(e)
    raise UnderMaintenance if e.response[:status] == 503

    raise e
  end

  def resource_not_found_handler!(e)
    raise UnderMaintenance if api.under_maintenance?

    remote_build_id = Buckler::Api::Client.remote_build_id
    if remote_build_id != build_id
      update(build_id: remote_build_id)
      raise BuildIdChanged
    end

    raise e
  end

  def forbidden_error_handler!(e)
    if with_lock { expired! unless expired? }
      # TODO: run the login using a one off dyno instead a job
      BucklerLoginJob.perform_later
    end

    raise e
  end
end
