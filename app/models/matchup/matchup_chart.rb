class Matchup::MatchupChart
  extend ActiveModel::Translation
  include Enumerable

  Item = Data.define(:character_id, :input_type_id, :score)

  def initialize(matchups)
    @matchups = matchups
  end

  def each(&)
    data.each(&)
  end

  def score_for(character_id:, input_type_id:)
    find { it.character_id == character_id && it.input_type_id == input_type_id }
      &.score
  end

  def total
    filter_map(&:score).reduce(&:+)
  end

  private

  def data
    @data ||= base_query.scoreboard.map do |score, attrs|
      Item.new(
        character_id: attrs[:away_character_id],
        input_type_id: attrs[:away_input_type_id],
        score:
      )
    end
  end

  def base_query
    @matchups
      .group(:away_character_id, :away_input_type_id)
      .select(:away_character_id, :away_input_type_id)
  end
end
