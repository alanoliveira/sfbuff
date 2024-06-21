# frozen_string_literal: true

case status
when 'success'
  turbo_stream.replace 'search-result', partial: 'buckler/player_search_result', locals: { data: }
when 'error'
  turbo_stream.replace 'search-result', html: alert(t("jobs.errors.#{data[:kind]}"), kind: 'danger')
end
