class Match < ApplicationRecord
  attribute :home_rounds, :round, json_array: true
  attribute :away_rounds, :round, json_array: true

  def self.aggregate_results
    ResultAggregation.new(all)
  end

  def self.daily_results
    group_by_day(:played_at)
      .then { it.select("#{it.group_values.last} date") }
      .order("date")
      .aggregate_results
      .to_h { |data, score| [ data["date"], score ] }
  end

  def readonly?
    true
  end
end
