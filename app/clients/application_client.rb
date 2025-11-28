class ApplicationClient
  class_attribute :user_agent, instance_writer: false, default: ENV["SFBUFF_DEFAULT_USER_AGENT"]
  class_attribute :base_url, instance_writer: false

  class Error < StandardError; end

  class HttpError < Error
    def initialize(response)
      @response = response
      super("the server responded with status #{response.status}")
    end
  end

  private

  def connection
    Faraday.new base_url do |conn|
      conn.response :logger, Rails.logger, { headers: false, bodies: false, errors: true }
      conn.headers["User-Agent"] = user_agent
      configure_connection(conn) if respond_to?(:configure_connection, true)
    end
  end
end
