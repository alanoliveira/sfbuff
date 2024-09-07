module Buckler::Api::Connection
  def self.build(base_url: nil, user_agent: nil, rescue_handler: nil)
    base_url ||= Rails.configuration.buckler["base_url"]
    user_agent ||= Rails.configuration.buckler["user_agent"]

    Faraday.new base_url do |conf|
      conf.headers["User-Agent"] = user_agent
      conf.use :rescue_from_error, handler: rescue_handler if rescue_handler.present?
      conf.response :raise_error
      conf.response :json
      conf.response :logger, Rails.logger.tagged("BucklerAPI")
      yield(conf) if block_given?
    end
  end
end
