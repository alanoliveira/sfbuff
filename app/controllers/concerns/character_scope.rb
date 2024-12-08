module CharacterScope
  extend ActiveSupport::Concern

  included do
    before_action :set_character
    layout "characters"
  end

  private

  def set_character
    @character = Character.new(params[:home_character])
    @control_type = ControlType.new(params[:home_control_type])
  end
end
