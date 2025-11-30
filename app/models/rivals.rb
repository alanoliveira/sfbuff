class Rivals
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  Result = Struct.new(:name, :fighter_id, :character_id, :input_type_id, :score) do
    def character = Character[character_id]
    def input_type = InputType[input_type_id]
  end

  def initialize(matches)
    @matches = matches
      .group("away_fighter_id", "away_character_id", "away_input_type_id")
      .select(
        "away_fighter_id fighter_id",
        "away_character_id character_id",
        "away_input_type_id input_type_id",
        "ANY_VALUE(away_name) name"
      )
  end

  def favorites(limit = nil)
    fetch_data(limit, { "total" => "desc", "wins" => "desc", "losses" => "desc" })
  end

  def victims(limit = nil)
    fetch_data(limit, { "diff" => "desc", "losses" => "asc", "wins" => "desc" })
  end

  def tormentors(limit = nil)
    fetch_data(limit, { "diff" => "asc", "wins" => "asc", "losses" => "desc" })
  end

  private

  def fetch_data(limit, order)
    @matches
      .limit(limit)
      .order(order)
      .aggregate_results
      .map { |data, score| Result.new(**data, score:) }
  end
end
