module SearchRequestsHelper
  def search_request_form(query)
    auto_submit_form_with url: fighter_searches_path(query:)
  end
end
