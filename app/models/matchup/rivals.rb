class Matchup::Rivals
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  Item = Data.define(:score, :name, :fighter_id, :character, :input_type, :matchup)

  attr_reader :matchup, :limit

  def initialize(matchup, limit)
    @matchup = matchup
    @limit = limit
  end

  def favorites
    build_scoreboard("total" => "desc")
  end

  def victims
    build_scoreboard("diff" => "asc", "lose" => "desc", "win" => "asc")
  end

  def tormentors
    build_scoreboard("diff" => "desc", "win" => "desc", "lose" => "asc")
  end

  private

  def build_scoreboard(order)
    matchup.away_challengers
      .group(:fighter_id, :character_id, :input_type_id)
      .select("ANY_VALUE(name) name", :fighter_id, :character_id, :input_type_id)
      .limit(limit)
      .order(order)
      .scoreboard
      .map { |score, *group| build_item(score, *group) }
  end

  def build_item(score, name, fighter_id, character_id, input_type_id)
    character, input_type = Character[character_id], InputType[input_type_id]
    item_matchup = matchup_for_item(fighter_id, character, input_type)
    Item.new(~score, name, fighter_id, character, input_type, item_matchup)
  end

  def matchup_for_item(away_fighter_id, away_character, away_input_type)
    matchup.dup.tap do
      it.assign_attributes(away_fighter_id:, away_character:, away_input_type:,)
    end
  end
end
