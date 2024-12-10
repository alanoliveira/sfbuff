class Rivals
  include ActiveModel::API

  attr_reader :matchup, :limit

  delegate :cache_key, :cache_version, to: :matchup

  def initialize(matchup, limit: nil)
    @matchup = matchup
    @limit = limit
  end

  def favorites(&)
    enumerate("total" => :desc, &)
  end

  def victims(&)
    enumerate("diff" => :desc, "win" => :desc, "lose" => :asc, &)
  end

  def tormentors(&)
    enumerate("diff" => :asc, "lose" => :desc, "win" => :asc, &)
  end

  private

  def enumerate(order)
    return to_enum(:enumerate, order) unless block_given?

    rivals.order(order).each do |group, score|
      short_id = ShortId.new(group["short_id"])
      character = Character.new(group["character"])
      control_type = ControlType.new(group["control_type"])
      name = group["name"]
      yield({ short_id:, character:, control_type:, name:, score: })
    end
  end

  def rivals
    matchup
      .performance
      .group(away: [ :short_id, :character, :control_type ])
      .select(
        Arel.sql("ANY_VALUE(away.name)").as("name"),
        away: [ :short_id, :character, :control_type ]
      )
      .limit(limit)
  end
end
