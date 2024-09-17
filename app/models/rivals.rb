class Rivals
  def initialize(scorable)
    @scorable = scorable.group(vs: [ :short_id, :character, :control_type ])
      .select(Arel.sql("ANY_VALUE(vs.name)").as("name"), vs: [ :short_id, :character, :control_type ])
  end

  def favorites
    @scorable.order("total" => :desc).scores
  end

  def victims
    @scorable.order("diff" => :desc, "win" => :desc, "lose" => :asc).scores
  end

  def tormentors
    @scorable.order("diff" => :asc, "lose" => :desc, "win" => :asc).scores
  end
end
