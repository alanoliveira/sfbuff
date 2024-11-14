module Matchup
  module Performance
    def sum
      map(&:second).reduce(Score.zero) do |total, item|
        total + item
      end
    end

    def group_by_matchup
      select([ away: [ :character, :control_type ] ])
        .group([ away: [ :character, :control_type ] ])
    end

    def group_by_rival
      group(away: [ :short_id, :character, :control_type ])
        .select(
          Arel.sql("ANY_VALUE(away.name)").as("name"),
          away: [ :short_id, :character, :control_type ]
        )
    end

    def favorites
      order("total" => :desc)
    end

    def victims
      order("diff" => :desc, "win" => :desc, "lose" => :asc)
    end

    def tormentors
      order("diff" => :asc, "lose" => :desc, "win" => :asc)
    end

    def select_values
      super | [
        win_column.as("win"),
        lose_column.as("lose"),
        ArelHelpers.count_if(arel_column("battles.winner_side").eq(nil)).as("draw"),
        Arel::Nodes::Subtraction.new(win_column, lose_column).as("diff"),
        Arel::Nodes::Count.new([ 1 ]).as("total")
      ]
    end

    def load
      @records ||= with_connection do |conn|
        conn.select_all(self, "#{__FILE__}:#{__LINE__}", async: @async).then do |rows|
          rows.map do |row|
            score = Score.new(**row.extract!(*Score.members.map(&:to_s)))
            [ row, score ]
          end
        end
      end
    end

    private

    def win_column
      ArelHelpers.count_if(arel_column("battles.winner_side").eq(arel_column("home.side")))
    end

    def lose_column
      ArelHelpers.count_if(arel_column("battles.winner_side").eq(arel_column("away.side")))
    end
  end
end
