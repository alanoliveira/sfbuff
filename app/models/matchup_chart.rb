class MatchupChart
  include Enumerable

  def initialize(rel)
    @rel = rel
  end

  def each
    Buckler::Enums::CHARACTERS.values.each do |character|
      Buckler::Enums::CONTROL_TYPES.values.each do |control_type|
        values = { character:, control_type: }.stringify_keys
        yield statistics.find { |s| s[:values] == values } || { score: nil, values: }
      end
    end
  end

  def sum
    statistics.map { _1[:score] }.reduce(&:+)
  end

  private

  def statistics
    @statistics ||= Statistics.new(
      @rel.group(vs: [ :character, :control_type ])
          .select(vs: [ :character, :control_type ])
    ).to_a
  end
end
