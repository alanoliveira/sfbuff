# frozen_string_literal: true

module ApplicationHelper
  def reloader(url)
    content_tag :div, spinner, class: 'text-center', data: {
      controller: 'interval-reloader',
      interval_reloader_url_value: url
    }
  end

  def time_ago(time)
    content_tag :span, t('common.time_ago', time: time_ago_in_words(time)),
                data: { controller: 'time-title', time_title_time_value: time.iso8601 }
  end

  def alert(message = nil, kind: :info, dismissible: false)
    classes = ['alert', "alert-#{kind}"]
    classes.push('alert-dismissible', 'fade', 'show') if dismissible
    content_tag(:div, message, class: classes, role: 'alert') do
      concat message if message.present?
      concat yield if block_given?
      concat content_tag(:button, '', class: 'btn-close', type: 'button', data: { bs_dismiss: 'alert' }) if dismissible
    end
  end

  def date_local_field(object_name, method = nil, **options)
    content_tag :span, data: { controller: 'date-local' } do
      concat date_field_tag(object_name, nil, data: { date_local_target: 'input' }, **options.slice(:class))
      concat hidden_field_tag(nil, method, data: { date_local_target: 'hidden' }, **options)
    end
  end

  def job_error_alert(error)
    message = case error[:class]
              when 'PlayerSynchronizer::PlayerNotFoundError' then t('errors.player_not_found')
              else t('errors.generic')
              end
    alert(message, kind: :danger)
  end

  def spinner
    content_tag :div, class: 'spinner-border', role: 'status' do
      content_tag :span, t('common.loading'), class: 'visually-hidden'
    end
  end

  def link_to_player(name, sid)
    link_to name, player_path(sid), data: { turbo_frame: :_top }
  end
end
