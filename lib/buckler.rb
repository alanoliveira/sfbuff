# frozen_string_literal: true

module Buckler
  Credentials = Struct.new(:build_id, :cookies)

  def self.build_api(credentials, config = {})
    credentials = Credentials.new(**credentials) if credentials.is_a? Hash
    client = Client.new(credentials, config)
    Api.new(client)
  end

  class Configuration
    attr_accessor :base_url, :cid_domain, :user_agent, :email, :password, :locale

    def initialize
      @base_url = nil
      @cid_domain = nil
      @user_agent = nil
      @email = nil
      @password = nil
      @locale = nil
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

  CHARACTERS = {
    ryu: 1,
    luke: 2,
    kimberly: 3,
    chun_li: 4,
    mannon: 5,
    zangief: 6,
    jp: 7,
    dhalsim: 8,
    cammy: 9,
    ken: 10,
    dee_jay: 11,
    lilly: 12,
    aki: 13,
    rashid: 14,
    blanka: 15,
    juri: 16,
    marisa: 17,
    guile: 18,
    ed: 19,
    e_honda: 20,
    jamie: 21,
    akuma: 22,
    m_bison: 23,
    # terry: 24,
    # mai: 25,
    # elena: 26,
    random: 254
  }.freeze

  BATTLE_TYPES = {
    ranked: 1,
    casual_match: 2,
    battle_hub: 3,
    custom_room: 4
  }.freeze

  BATTLE_SUBTYPES = {
    none: 1
  }.freeze

  CONTROL_TYPES = {
    classic: 0,
    modern: 1
  }.freeze

  ROUNDS = {
    l: 0,
    v: 1,
    c: 2,
    t: 3,
    d: 4,
    od: 5,
    sa: 6,
    ca: 7,
    p: 8
  }.freeze
end
