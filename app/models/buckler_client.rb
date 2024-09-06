class BucklerClient < ApplicationRecord
  include ActiveSupport::Rescuable

  def api
    @api ||= Buckler::Api::Client.new(cookies:, build_id:, connection:)
  end

  private

  def connection
    rescue_handler = ->(e) { rescue_with_handler(e) || raise }
    Buckler::Api::Connection.build(rescue_handler:)
  end
end
