module Challenger::JoinVs
  TABLE_ALIAS = "vs"

  def self.call
    arel_table = Challenger.arel_table
    vs_table = Challenger.arel_table.alias(TABLE_ALIAS)

    arel_table.join(vs_table).on(
      vs_table[:battle_id].eq(arel_table[:battle_id])
        .and(vs_table[:id].not_eq(arel_table[:id]))
    ).join_sources.then { Challenger.joins(_1) }
  end
end
