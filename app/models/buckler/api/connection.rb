module Buckler::Api::Connection
  BASE_URL = ENV.fetch("BUCKLER_BASE_URL", nil)
  USER_AGENT = ENV.fetch("BUCKLER_USER_AGENT", nil)

  def self.build(base_url: BASE_URL, user_agent: USER_AGENT)
    Faraday.new base_url do |conf|
      conf.headers["User-Agent"] = user_agent
      conf.response :raise_error
      conf.response :json
      conf.response :logger, Rails.logger.tagged("BucklerAPI")
      yield(conf) if block_given?
    end
  end
end
