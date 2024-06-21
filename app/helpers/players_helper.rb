# frozen_string_literal: true

module PlayersHelper
  def player_search_form
    form_with url: search_players_path, method: :get, role: 'search' do |f|
      content_tag :div, class: 'input-group' do
        concat(f.text_field(:q, value: params[:q], placeholder: t('helpers.players.search_placeholder'),
                                type: 'search', required: true, minlength: 4, class: 'form-control'))
        concat(submit_button('search', name: nil, class: 'btn btn-primary'))
      end
    end
  end
end
