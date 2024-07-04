# frozen_string_literal: true

class Period
  PERIODS = %w[day week month].freeze

  attr_reader :period

  def initialize(period)
    raise ArgumentError unless PERIODS.include? period

    @period = period
  end

  def to_s
    period
  end

  def to_datetime_range
    case period
    when 'week' then (1.week.ago..)
    when 'month' then (1.month.ago..)
    else (1.day.ago..)
    end
  end
end
