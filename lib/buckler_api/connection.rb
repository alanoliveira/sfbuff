module BucklerApi
  class Connection
    attr_reader :base_url, :user_agent, :logger

    def initialize(base_url: nil, user_agent: nil, logger: nil, &faraday_cfg)
      @base_url = base_url || Configuration.base_url
      @user_agent = user_agent || Configuration.user_agent
      @logger = logger || Configuration.logger
      @faraday_cfg = faraday_cfg
    end


    def get(path, params: {}, headers: {})
      faraday.get(path, params) do |req|
        req.headers = req.headers.merge(headers)
      end
    end

    private

    def faraday
      Faraday.new base_url, headers: { "User-Agent" => user_agent } do |conf|
        conf.response :logger, logger, { headers: false, bodies: false, errors: true }
        conf.response :json
        @faraday_cfg&.call(conf)
      end
    end
  end
end
