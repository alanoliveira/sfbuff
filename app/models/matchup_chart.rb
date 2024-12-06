class MatchupChart
  include ActiveModel::API
  include Enumerable

  attr_reader :matchup

  def initialize(matchup)
    @matchup = matchup
  end

  def each
    Character.to_a.product(ControlType.to_a).each do |character, control_type|
      score = items.find { |group, _| [ character, control_type ] == group.values_at("character", "control_type") }&.second
      yield({ character:, control_type:, score: })
    end
  end

  def sum
    items.map { |_, score| score }.reduce(Score.zero, &:+)
  end

  private

  def items
    @items ||= matchup
      .performance
      .group(away: [ :character, :control_type ])
      .select(away: [ :character, :control_type ])
  end
end
