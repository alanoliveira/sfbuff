module ArelHelpers
  def self.count_if(condition)
    Arel::Nodes::Filter.new(Arel::Nodes::Count.new([ 1 ]), condition)
  end
end
