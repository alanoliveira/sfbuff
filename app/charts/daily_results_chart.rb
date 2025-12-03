class DailyResultsChart < ApplicationChart
  attr_reader :daily_results

  def initialize(daily_results)
    @daily_results = daily_results
  end

  def labels
    daily_results.keys
  end

  def wins_data
    daily_results.values.map(&:wins)
  end

  def losses_data
    daily_results.values.map(&:losses)
  end

  def draws_data
    daily_results.values.map(&:draws)
  end
end
