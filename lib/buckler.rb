module Buckler
  class InvalidShortId < ArgumentError; end

  class Configuration
    attr_accessor :base_url, :user_agent, :email, :password, :logger

    def initialize
      @base_url = nil
      @user_agent = nil
      @email = nil
      @password = nil
      @logger = Logger.new(IO::NULL)
    end
  end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
