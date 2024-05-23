# frozen_string_literal: true

class ResultCounter
  Result = Struct.new(:wins, :loses, :character, :control_type, :opponent_name)

  def initialize(**params)
    @battles_rel = params[:battles_rel]
  end

  def call; end

  private

  attr_accessor :battles_rel

  def count
    battles_rel
      .includes(challengers: :vs)
      .pluck(Arel.sql('
        winner_side,
        vs_challengers.side,
        vs_challengers.character,
        vs_challengers.control_type,
        vs_challengers.player_sid,
        vs_challengers.name'))
  end
end
