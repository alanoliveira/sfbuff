module PlayerScope
  extend ActiveSupport::Concern

  included do
    before_action :set_player
    layout "players"
  end

  private

  def set_player
    @player = Player.find_or_initialize_by(short_id: params[:short_id])
  end
end
