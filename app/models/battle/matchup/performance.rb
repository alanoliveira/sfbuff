class Battle::Matchup::Performance
  def initialize(matchups, select: nil, group: nil, limit: nil)
    @matchups = matchups.extending(Scoring)
  end

  def score
    @matchups.score
  end

  def favorites
    @matchups.order("total" => :desc).score
  end

  def victims
    @matchups.order("diff" => :desc, "win" => :desc, "lose" => :asc).score
  end

  def tormentors
    @matchups.order("diff" => :asc, "lose" => :desc, "win" => :asc).score
  end

  def limit(...)
    self.class.new(@matchups.limit(...))
  end

  def group(...)
    self.class.new(@matchups.group(...))
  end

  def select(...)
    self.class.new(@matchups.select(...))
  end

  module Scoring
    COLUMNS = %w[win lose draw total diff]

    def score
      group_values.any? ? grouped_score : simple_score
    end

    def grouped_score
      klass.with_connection do |conn|
        conn.select_all(all, "#{self.class.name}#grouped_scores", async: @async).then do |rows|
          rows.map do |row|
            score = Score.new(**row.extract!(*COLUMNS))
            { row => score }
          end
        end
      end
    end

    def simple_score
      klass.with_connection do |conn|
        conn.select_one(all, "#{self.class.name}#simple_score", async: @async).then { Score.new(**_1) }
      end
    end

    def select_values
      super | [
        win_column.as("win"),
        lose_column.as("lose"),
        ArelHelpers.count_if(arel_column("battles.winner_side").eq(nil)).as("draw"),
        Arel::Nodes::Subtraction.new(win_column, lose_column).as("diff"),
        Arel::Nodes::Count.new([ 1 ]).as("total"),
        *group_values
      ]
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
