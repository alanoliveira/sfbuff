module MatchSimulatorHelper
  def build_match(p1: {}, p2: {}, battle: {})
    battle = build_battle(**battle)
    battle.p1 = build_challenger(:p1, **p1)
    battle.p2 = build_challenger(:p2, **p2)

    battle
  end

  def create_match(...)
    build_match(...).tap(&:save!)
  end

  private

  def build_battle(**params)
    params[:played_at] ||= rand(Time.new(2024)..Time.new(2024).end_of_year)
    build(:battle, **params)
  end

  def build_challenger(side, **params)
    params[:character_id] ||= rand(1..20)
    params[:playing_character_id] ||= rand(1..20)
    params[:input_type_id] ||= [ 0, 1 ].sample
    params[:master_rating] ||= rand(1000..2000)
    params[:league_point] ||= params[:master_rating] + 11_111
    build(side, **params)
  end
end
