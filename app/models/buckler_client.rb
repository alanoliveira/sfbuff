class BucklerClient < ApplicationRecord
  def api
    @api ||= Buckler::Api::Client.new(cookies:, build_id:)
  end
end
