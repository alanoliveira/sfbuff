module Buckler::Api
  class Client
    attr_reader :build_id, :cookies, :locale, :connection

    def self.remote_build_id(connection = Connection.build)
      connection.get("/6/buckler").body[/"buildId":"([^"]*)"/, 1] or raise("Unexpected response")
    end

    def initialize(cookies:, build_id: self.class.remote_build_id, locale: "en", connection: Connection.build)
      @build_id = build_id
      @cookies = cookies
      @locale = locale
      @connection = connection
    end

    def replay_list(short_id:)
      Replays.new(short_id:, client: self)
    end

    def fighter_banner
      FighterBanner.new(client: self)
    end

    def request(action_path:, params: nil)
      connection.get(full_path(action_path), params, headers).body.fetch("pageProps")
    end

    private

    def full_path(action_path)
      "/6/buckler/_next/data/#{build_id}/#{locale}/#{action_path}"
    end

    def headers
      { "Cookie" => cookies }
    end
  end
end
