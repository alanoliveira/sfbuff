class Rivals
  def initialize(rel)
    @rel = rel.group(vs: [ :short_id, :character, :control_type ])
      .select(Arel.sql("ANY_VALUE(vs.name)").as("name"), vs: [ :short_id, :character, :control_type ])
  end

  def favorites
    Statistics.new(@rel.order("total" => :desc))
  end

  def victims
    Statistics.new(@rel.order("diff" => :desc, "win" => :desc, "lose" => :asc))
  end

  def tormentors
    Statistics.new(@rel.order("diff" => :asc, "lose" => :desc, "win" => :asc))
  end
end
