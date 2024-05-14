# frozen_string_literal: true

module Buckler
  Credentials = Struct.new(:build_id, :cookies)

  def self.build_api(credentials, config = {})
    credentials = Credentials.new(**credentials) if credentials.is_a? Hash
    client = Client.new(credentials, config)
    Api.new(client)
  end

  class Configuration
    attr_accessor :base_url, :cid_domain, :user_agent, :email, :password

    def initialize
      @base_url = nil
      @cid_domain = nil
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

  CHARACTERS = {
    1 => 'RYU',
    2 => 'LUK',
    3 => 'KIM',
    4 => 'CHU',
    5 => 'MAN',
    6 => 'ZAN',
    7 => 'JP',
    8 => 'DHA',
    9 => 'CAM',
    10 => 'KEN',
    11 => 'DJ',
    12 => 'LIL',
    13 => 'AKI',
    14 => 'RAS',
    15 => 'BLA',
    16 => 'JUR',
    17 => 'MAR',
    18 => 'GUI',
    19 => 'ED',
    20 => 'HON',
    21 => 'JAM',
    254 => 'RDN'
  }.freeze

  BATTLE_TYPES = {
    1 => 'Ranked',
    4 => 'Custom Room'
  }.freeze

  BATTLE_SUBTYPES = {
    1 => 'None'
  }.freeze

  CONTROL_TYPES = {
    0 => 'Classic',
    1 => 'Modern'
  }.freeze

  ROUNDS = {
    0 => 'L',
    1 => 'V',
    2 => 'C',
    3 => 'T',
    4 => 'D',
    5 => 'OD',
    6 => 'SA',
    7 => 'CA',
    8 => 'P'
  }.freeze
end
