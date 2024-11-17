module ArelHelpers
  def self.count_if(condition)
    Arel::Nodes::Filter.new(Arel::Nodes::Count.new([ 1 ]), condition)
  end

  def self.convert_tz(col, from: "utc", to: "utc")
    at_time_zone(col, from).then { at_time_zone(_1, to) }
  end

  def self.at_time_zone(col, zone)
    Arel::Nodes::InfixOperation.new(Arel.sql("AT TIME ZONE"), col, Arel::Nodes::Quoted.new(zone))
  end

  def self.date(*args)
    Arel::Nodes::NamedFunction.new(Arel.sql("DATE"), args)
  end
end
