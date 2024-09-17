class MatchupChart
  include Enumerable

  def initialize(scorable)
    @scorable = scorable
  end

  def each
    Buckler::Enums::CHARACTERS.values.each do |character|
      Buckler::Enums::CONTROL_TYPES.values.each do |control_type|
        values = { character:, control_type: }.stringify_keys
        yield scores.find { |_, r| r == values } || [ nil, values ]
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
