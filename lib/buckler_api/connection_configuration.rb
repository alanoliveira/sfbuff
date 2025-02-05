module BucklerApi
  class ConnectionConfiguration
    attr_writer :adapter
    attr_accessor :base_url, :user_agent

    def adapter
      @adapter ||= BucklerApi::Adapters::FaradayAdapter.new
    end

    def build_id_manager
      @build_id_manager ||= StrategySelector.new
    end

    def auth_cookies_manager
      @auth_cookies_manager ||= StrategySelector.new
    end
  end
end
