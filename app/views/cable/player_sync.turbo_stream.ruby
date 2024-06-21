# frozen_string_literal: true

case status
when 'success'
  turbo_stream.action 'refresh', 'sync-result'
when 'error'
  turbo_stream.replace 'sync-result', html: job_error_alert(data[:kind])
end
