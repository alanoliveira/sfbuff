class MatchupChart
  include Enumerable

  def initialize(rel)
    @rel = rel
  end

  def each
    Buckler::Enums::CHARACTERS.values.each do |character|
      Buckler::Enums::CONTROL_TYPES.values.each do |control_type|
        values = { character:, control_type: }.stringify_keys
        yield statistics.find { |_, r| r == values } || [ nil, values ]
      end
    end
  end

  private

  def statistics
    @statistics ||= Statistics.new(
      @rel.group(vs: [ :character, :control_type ])
          .select(vs: [ :character, :control_type ])
    )
  end
end
