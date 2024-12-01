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

  CHARACTERS = {
    "ryu" => 1,
    "luke" => 2,
    "kimberly" => 3,
    "chun_li" => 4,
    "manon" => 5,
    "zangief" => 6,
    "jp" => 7,
    "dhalsim" => 8,
    "cammy" => 9,
    "ken" => 10,
    "dee_jay" => 11,
    "lilly" => 12,
    "aki" => 13,
    "rashid" => 14,
    "blanka" => 15,
    "juri" => 16,
    "marisa" => 17,
    "guile" => 18,
    "ed" => 19,
    "e_honda" => 20,
    "jamie" => 21,
    "akuma" => 22,
    "m_bison" => 26,
    "terry" => 27,
    # "mai" => ?,
    # "elena" => ?,
    "random" => 254
  }.freeze

  BATTLE_TYPES = {
    "ranked" => 1,
    "casual_match" => 2,
    "battle_hub" => 3,
    "custom_room" => 4
  }.freeze

  CONTROL_TYPES = {
    "classic" => 0,
    "modern" => 1
  }.freeze
end
