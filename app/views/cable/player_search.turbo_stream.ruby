# frozen_string_literal: true

case status
when 'success'
  turbo_stream.replace 'search-result', partial: 'cable/search_result', locals: { data: }
when 'error'
  turbo_stream.replace 'search-result', html: job_error_alert(data.class.name), locals: { data: }
end
