class Matchup::Rivals
  extend ActiveModel::Translation

  Item = Data.define(:fighter_id, :character_id, :input_type_id, :name, :score)

  def initialize(matchups)
    @matchups = matchups
  end

  def favorites
    @favorites ||= fetch("total" => "desc", "wins" => "desc", "losses" => "desc")
  end

  def victims
    @victims ||= fetch("diff" => "desc", "losses" => "asc", "wins" => "desc")
  end

  def tormentors
    @tormentors ||= fetch("diff" => "asc", "wins" => "asc", "losses" => "desc")
  end

  private

  def fetch(order)
    base_query.order(order).scoreboard.map do |score, attrs|
      Item.new(
        fighter_id: attrs[:away_fighter_id],
        character_id: attrs[:away_character_id],
        input_type_id: attrs[:away_input_type_id],
        name: attrs[:away_name],
        score:
      )
    end
  end

  def base_query
    @matchups
      .group(:away_fighter_id, :away_character_id, :away_input_type_id)
      .select(:away_fighter_id, :away_character_id, :away_input_type_id, "ANY_VALUE(away_name) away_name")
  end
end
