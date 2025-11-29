module FighterScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_fighter
  end

  private

  def set_fighter
    @fighter = Fighter.find_or_initialize_by(id: params[:fighter_id])
  end
end
