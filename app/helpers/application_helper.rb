# frozen_string_literal: true

module ApplicationHelper
  def page_title(title)
    content_for(:title) { title }
    content_tag :h1, title
  end

  def head_title
    title = 'SFBUFF'
    title += " - #{content_for(:title)}" if content_for?(:title)
    content_tag :title, title
  end

  def nav_link(name, url)
    classes = ['nav-link']
    classes << 'active' if current_page? url
    link_to name, url, class: classes
  end

  def time_ago(time)
    content_tag :span, t('helpers.datetime.time_ago', time: time_ago_in_words(time)),
                title: l(time, format: :short)
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

  def spinner
    content_tag :div, class: 'spinner-border', role: 'status' do
      content_tag :span, t('common.loading'), class: 'visually-hidden'
    end
  end

  def link_to_player(name, sid)
    link_to name, player_path(sid), data: { turbo_frame: :_top }
  end

  def diff_span(diff)
    css_class = case diff
                when ..-1 then 'text-danger'
                when 1.. then 'text-success'
                else ''
                end
    content_tag(:span, format('%+d', diff), class: css_class)
  end

  def reset_button(**)
    link_to t('actions.reset'), url_for(only_path: true), **
  end

  def language_select(**)
    options = options_for_select(
      { 'English' => 'en', 'Português' => 'pt-BR', '日本語' => 'ja' },
      I18n.locale
    )
    select_tag 'language-select', options, data: { controller: 'language-select' }, **
  end

  def period_select(form, attribute, **)
    choises = PeriodSearchable::PERIODS.transform_keys { t("helpers.periods.#{_1}") }
    select_list(form, attribute, choises, include_any: false, **)
  end

  def select_list(form, attribute, choises, include_any: false, **)
    opts = {}
    opts[:include_blank] = t('helpers.select.any') if include_any
    form.select(
      attribute,
      choises,
      opts,
      **
    )
  end
end
