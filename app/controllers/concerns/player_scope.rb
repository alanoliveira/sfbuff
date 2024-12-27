module PlayerScope
  extend ActiveSupport::Concern

  included do
    before_action :set_player
    layout "players"
  end

  private

  def set_player
    @player = Player.find_or_create(params[:short_id])
  rescue ArgumentError
    render file: "#{Rails.root}/public/404.html", status: 404, layout: false
  end
end
