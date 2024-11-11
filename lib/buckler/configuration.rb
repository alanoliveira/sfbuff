module Buckler
  class Configuration
    attr_accessor :base_url, :user_agent, :email, :password

    def initialize
      @base_url = nil
      @user_agent = nil
      @email = nil
      @password = nil
    end
  end
end
