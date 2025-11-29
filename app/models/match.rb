class Match < ApplicationRecord
  attribute :home_rounds, :round, json_array: true
  attribute :away_rounds, :round, json_array: true

  def self.aggregate_results
    ResultAggregation.new(all)
  end

  def readonly?
    true
  end
end
