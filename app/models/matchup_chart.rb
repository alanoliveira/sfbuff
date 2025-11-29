class MatchupChart
  def initialize(matches)
    @matches = matches
  end

  def get(character_id:, input_type_id:)
    data[{ "away_character_id" => character_id, "away_input_type_id" => input_type_id }] || Score.empty
  end

  def sum
    @sum ||= data.values.reduce(&:+) || Score.empty
  end

  delegate :empty?, to: :data

  private

  def data
    @data ||= fetch_data.to_h
  end

  def fetch_data
    @matches
      .select(:away_character_id, :away_input_type_id)
      .group(:away_character_id, :away_input_type_id)
      .aggregate_results
  end
end
