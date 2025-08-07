class RankedHistory
  include Enumerable
  extend ActiveModel::Translation

  Step = Data.define(:played_at, :replay_id, :mr, :lp, :mr_variation, :lp_variation) do
    def calibrating?
      mr == 0 && lp == -1
    end
  end

  attr_reader :fighter_id, :character_id, :from_date, :to_date

  delegate :any?, to: :execute

  def initialize(fighter_id:, character_id:, from_date: nil, to_date: nil)
    @fighter_id = fighter_id
    @character_id = character_id
    @from_date = from_date || Date.today
    @to_date = to_date || Date.today
  end

  def each(&)
    data.each(&)
  end

  def extra_step
    @extra_step ||= ExtraStep.new(fighter_id:, character_id:, date: to_date)
  end

  private

  def data
    @data ||= execute.chain([ extra_step ]).each_cons(2).map do |data1, data2|
      Step.new(
        played_at: data1["played_at"],
        replay_id: data1["replay_id"],
        mr: data1["mr"],
        lp: data1["lp"],
        mr_variation: data2.present? && data2["mr"] - data1["mr"],
        lp_variation: data2.present? && data2["lp"] - data1["lp"],
      )
    end
  end

  def execute
    played_between = from_date.beginning_of_day .. to_date.end_of_day
    ActiveRecord::Base
      .lease_connection
      .select_all(ranked_steps.where(played_at: played_between))
  end

  def ranked_steps
    RankedStep.where(fighter_id:, character_id:).sorted
  end
end
