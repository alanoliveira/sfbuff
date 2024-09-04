module PlayerScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_player
  end

  private

  def set_player
    @player = Player.find_or_initialize_by(short_id: params[:player_short_id])
  end
end
