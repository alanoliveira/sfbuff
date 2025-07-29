class RankedHistory
  Step = Data.define(:played_at, :replay_id, :mr, :lp, :mr_variation, :lp_variation)

  include Enumerable
  include ActiveModel::Model
  include ActiveModel::Attributes

  QUERY = <<-SQL
    SELECT * FROM (
      SELECT replay_id,
             played_at,
             p1_fighter_id fighter_id,
             p1_character_id character_id,
             p1_mr mr,
             p1_lp lp
      FROM battles
      WHERE battle_type_id = 1
      UNION ALL
      SELECT replay_id,
             played_at,
             p2_fighter_id fighter_id,
             p2_character_id character_id,
             p2_mr mr,
             p2_lp lp
      FROM battles
      WHERE battle_type_id = 1
    ) WHERE fighter_id = :fighter_id
        AND character_id = :character_id
        AND played_at BETWEEN :from_date AND :to_date
      ORDER BY played_at
  SQL

  attribute :fighter_id
  attribute :character_id
  attribute :from_date, default: Date.today
  attribute :to_date, default: Date.today

  delegate :any?, to: :execute

  def each(&)
    data.each(&)
  end

  private

  def data
    execute.chain([ nil ]).each_cons(2).map do |data1, data2|
      Step.new(
        played_at: data1["played_at"],
        replay_id: data1["replay_id"],
        mr: data1["mr"],
        lp: data1["lp"],
        mr_variation: data2 && data2["mr"] - data1["mr"],
        lp_variation: data2 && data2["lp"] - data1["lp"],
      )
    end
  end

  def execute
    ActiveRecord::Base
      .lease_connection
      .select_all(sanitized_query)
  end

  def sanitized_query
    ApplicationRecord.sanitize_sql([ QUERY, query_params ])
  end

  def query_params
    {
      fighter_id:,
      character_id:,
      from_date: from_date&.beginning_of_day,
      to_date: to_date&.end_of_day
    }
  end
end
