# frozen_string_literal: true

module ResultBroadcastable
  extend ActiveSupport::Concern

  included do
    rescue_from(StandardError) do |error|
      I18n.with_locale(locale) do
        broadcast_result('error', { kind: resolve_error_kind(error) })
      end
      raise error
    end
  end

  def broadcast_result(status, data)
    channel.broadcast_to(job_id, status, data)
  end
end
