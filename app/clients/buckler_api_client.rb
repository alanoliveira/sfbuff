class BucklerApiClient < ApplicationClient
  self.base_url = ENV["BUCKLER_BASE_URL"] || "https://www.streetfighter.com"

  class BucklerApiHttpError < HttpError; end
  class UnderMaintenance < BucklerApiHttpError; end
  class RateLimitExceeded < BucklerApiHttpError; end
  class Unauthorized < BucklerApiHttpError; end
  class PageNotFound < BucklerApiHttpError; end
  class ServerError < BucklerApiHttpError; end

  attr_reader :build_id, :auth_cookie

  def initialize(build_id: AppSetting.buckler_build_id, auth_cookie: AppSetting.buckler_auth_cookie)
    @build_id = build_id
    @auth_cookie = auth_cookie
  end

  def fighterslist(short_id: nil, fighter_id: nil)
    params = { short_id:, fighter_id: }.compact
    raise ArgumentError, "short_id XOR fighter_id is required" if params.length != 1

    get "fighterslist/search/result.json", params
  end

  def battlelog(short_id)
    paginate "profile/#{short_id}/battlelog.json", first_page: 1, last_page: 10
  end

  def play_profile(short_id)
    get "profile/#{short_id}/play.json"
  end

  def friends
    get "fighterslist/friend.json"
  end

  private

  def paginate(path, params = nil, first_page:, last_page:)
    first_page.upto(last_page).lazy.map do |page|
      get path, page:, **params
    end
  end

  def get(path, params = nil)
    connection.get(path, params).body
  end

  def configure_connection(conn)
    conn.response :json
    conn.use ErrorHandlerMiddleware
    conn.path_prefix = "/6/buckler/_next/data/#{build_id}/en/"
    conn.headers["Cookie"] = auth_cookie
  end
end
