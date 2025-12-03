class BucklerSiteClient < ApplicationClient
  self.base_url = ENV["BUCKLER_BASE_URL"] || "https://www.streetfighter.com"

  def next_data
    response = connection.get("/6/buckler")
    NextDataResponseParser.new(response.body).parse
  end
end
