# frozen_string_literal: true

module Buckler
  Credentials = Struct.new(:build_id, :cookies)

  class Configuration
    attr_accessor :base_url, :user_agent, :email, :password

    def initialize
      @base_url = nil
      @user_agent = nil
      @email = nil
      @password = nil
    end
  end

  class << self
    def configuration
      @configuration ||= Buckler::Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
