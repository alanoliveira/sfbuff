# frozen_string_literal: true

module ApplicationHelper
  def reloader(url)
    content_tag :div, 'spinner', data: {
      controller: 'interval-reloader',
      interval_reloader_url_value: url
    }
  end
end
