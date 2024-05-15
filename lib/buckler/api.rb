# frozen_string_literal: true

module Buckler
  class Api
    attr_reader :client

    def initialize(client)
      @client = client
    end

    def battlelog(player_sid)
      validate_player_sid!(player_sid)

      Battlelog.new(client, player_sid)
    end

    def search_player_by_sid(player_sid)
      validate_player_sid!(player_sid)

      data = client.fighterslist(short_id: player_sid)
      data.fetch('pageProps').fetch('fighter_banner_list').first
    end

    def search_players_by_name(name)
      validate_name!(name)

      data = client.fighterslist(fighter_id: name)
      data.fetch('pageProps').fetch('fighter_banner_list')
    end

    private

    def validate_player_sid!(player_sid)
      raise ArgumentError unless player_sid.to_s.match(/\A\d{9,}\z/)
    end

    def validate_name!(name)
      raise ArgumentError if name.size < 4
    end
  end
end
