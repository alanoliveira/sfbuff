class BucklerApi::Client
  attr_accessor :connection, :locale

  def initialize(connection, locale)
    @connection = connection
    @locale = locale
  end

  def fighterslist(short_id: nil, fighter_id: nil)
    params = { short_id:, fighter_id: }.compact
    raise ArgumentError if params.count != 1

    get("fighterslist/search/result.json", params).fetch("fighter_banner_list")
  end

  def battlelog(short_id, page)
    get("profile/#{short_id}/battlelog.json", { page: }).fetch("replay_list")
  end

  private

  def get(path, params)
    connection.get(localized_path(path), **params).page_props
  end

  def localized_path(path)
    "#{locale}/#{path}"
  end
end
