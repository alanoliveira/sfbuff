class Matchup::MatchupChart
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include Enumerable

  Item = Data.define(:score, :character, :input_type, :matchup)

  attr_accessor :matchup

  def initialize(matchup)
    @matchup = matchup
  end

  def each(&)
    scoreboard = fetch_scoreboard
    Character.to_a.product(InputType.to_a).map do |character, input_type|
      score = scoreboard[[ character.id, input_type.id ]].try(:~)
      item_matchup = matchup_for_item(character, input_type)
      Item.new(score, character, input_type, item_matchup)
    end.each(&)
  end

  def sum
    filter_map(&:score).reduce(&:+)
  end

  private

  def fetch_scoreboard
    matchup
      .away_challengers
      .group(:character_id, :input_type_id)
      .select(:character_id, :input_type_id)
      .scoreboard
      .to_h { |score, *group| [ group, score ] }
  end

  def matchup_for_item(away_character, away_input_type)
    matchup.dup.tap do
      it.assign_attributes(away_character:, away_input_type:)
    end
  end
end
