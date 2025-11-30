module MatchupChartsHelper
  def foreach_character_and_input_type(matchup_chart, &)
    Character.all.product(InputType.all).each do |character, input_type|
      yield character:, input_type:, score: matchup_chart.get(character:, input_type:)
    end
  end
end
