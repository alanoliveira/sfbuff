class MatchupChart
  include Enumerable

  def initialize(scorable)
    @scorable = scorable
  end

  def each
    Buckler::Enums::CHARACTERS.values.each do |character|
      Buckler::Enums::CONTROL_TYPES.values.each do |control_type|
        group = { character:, control_type: }.stringify_keys
        yield scores.find { |g, _| g == group } || [ group, nil ]
      end
    end
  end

  private

  def scores
    @scores ||= @scorable
      .group(vs: [ :character, :control_type ])
      .select(vs: [ :character, :control_type ])
      .scores
  end
end
