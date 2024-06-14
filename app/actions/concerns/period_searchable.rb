# frozen_string_literal: true

module PeriodSearchable
  extend ActiveSupport::Concern

  PERIODS = { day: 1, week: 2, month: 3 }.freeze

  class_methods do
    def periods
      PERIODS
    end
  end

  def periods
    self.class.periods
  end

  def period_range
    case period
    when PERIODS[:week] then (1.week.ago..)
    when PERIODS[:month] then (1.month.ago..)
    else (1.day.ago..)
    end
  end
end
