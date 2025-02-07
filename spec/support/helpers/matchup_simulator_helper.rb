module MatchSimulatorHelper
  def build_match(p1: {}, p2: {}, battle: {}, result: nil)
    p1_result, p2_result = case result
    when :p1_win then [ Result::WIN, Result::LOSE ]
    when :p2_win then [ Result::LOSE, Result::WIN ]
    when :draw then [ Result::DRAW, Result::DRAW ]
    end

    battle = build_battle(**battle)
    battle.p1 = build_challenger(:p1, p1_result, **p1)
    battle.p2 = build_challenger(:p2, p2_result, **p2)

    battle
  end

  def create_match(...)
    build_match(...).tap(&:save!)
  end

  private

  def build_battle(**params)
    params[:played_at] ||= rand(1.week.ago..Time.now)
    build(:battle, **params)
  end

  def build_challenger(side, result = nil, **params)
    params[:character_id] ||= rand(1..20)
    params[:playing_character_id] ||= rand(1..20)
    params[:input_type_id] ||= [ 0, 1 ].sample
    params[:master_rating] ||= rand(1000..2000)
    params[:league_point] ||= params[:master_rating] + 11_111
    params[:round_ids] ||= round_for_result(result) if result
    build(side, **params)
  end

  def round_for_result(result)
    case result
    when Result::WIN then [ 1, 0, 1 ]
    when Result::LOSE then [ 1, 0, 0 ]
    when Result::DRAW then [ 1, 0, 4 ]
    end
  end
end
