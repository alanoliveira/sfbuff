module SearchRequestsHelper
  def search_request_form(query)
    auto_submit_form_with url: query_search_path(query)
  end
end
