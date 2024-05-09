# frozen_string_literal: true

module ApplicationHelper
  def reloader(url)
    content_tag :div, spinner, class: 'text-center', data: {
      controller: 'interval-reloader',
      interval_reloader_url_value: url
    }
  end

  def time_ago(time)
    content_tag :span, time_ago_in_words(time), title: l(time, format: :long)
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

  def job_error_alert(error)
    message = case error[:class]
              when 'PlayerSynchronizer::PlayerNotFoundError' then t('errors.player_not_found')
              else t('errors.generic')
              end
    alert(message, kind: :danger)
  end

  def spinner
    content_tag :div, class: 'spinner-border', role: 'status' do
      content_tag :span, t('loading'), class: 'visually-hidden'
    end
  end

  def link_to_player(name, sid)
    link_to name, player_path(sid), data: { turbo_frame: :_top }
  end

  def battle_type_span(battle_type_id)
    content_tag :span, Buckler::BATTLE_TYPES[battle_type_id]
  end

  def character_name(character_id)
    content_tag :span, Buckler::CHARACTERS[character_id]
  end

  def control_type(control_type_id)
    control_type = Buckler::CONTROL_TYPES[control_type_id]
    content_tag :span, control_type[0].upcase
  end

  def rival_score_span(diff)
    css_class = case diff
                when ..-1 then 'text-danger'
                when 1.. then 'text-success'
                else ''
                end
    content_tag(:span, format('%+d', diff), class: css_class)
  end

  def round_result(round_id)
    round = Buckler::ROUNDS[round_id]
    content_tag :span, round, style: 'width: 20px', class: "badge px-0 text-center round-#{round.downcase}"
  end
end
