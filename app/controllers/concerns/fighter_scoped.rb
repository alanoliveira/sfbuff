module FighterScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_fighter
  end

  class_methods do
    def fresh_when_unsynchronized(**)
      before_action(**) do
        fresh_when @fighter if @fighter.synchronized?
      end
    end
  end

  private

  def set_fighter
    @fighter = Fighter.find_or_initialize_by(id: params["fighter_id"])
  end
end
