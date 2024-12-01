class MatchupChart
  Line = Struct.new(:character, :control_type, :score)

  include Enumerable

  def self.from_matchup(matchup)
    matchup
      .performance
      .group_by_matchup
      .each_with_object(new) do |item, chart|
        group, score = item.to_a.flatten
        chart[**group.symbolize_keys].score = score
     end
  end

  def initialize
    @lines = Character.map(&:to_i).product(ControlType.map(&:to_i))
      .to_h { |char, ctrl| [ [ char, ctrl ], Line.new(char, ctrl, nil) ] }
  end

  def [](character:, control_type:)
    @lines[[ character, control_type ]]
  end

  def each(...)
    @lines.values.each(...)
  end

  def sum
    @lines.values.filter_map(&:score).reduce(Score.zero, &:+)
  end
end
