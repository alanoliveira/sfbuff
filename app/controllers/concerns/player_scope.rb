module PlayerScope
  extend ActiveSupport::Concern

  included do
    before_action :set_player
    layout "players"
  end

  private

  def set_player
    @player = Player.find_or_create(params[:short_id])
    @sync_job = PlayerSynchronizeJob.perform_later(@player.short_id.to_i) unless @player.synchronized?
  rescue ArgumentError
    render file: "#{Rails.root}/public/404.html", status: 404, layout: false
  end
end
