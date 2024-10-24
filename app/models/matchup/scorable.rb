module Matchup::Scorable
  extend ActiveSupport::Concern

  class_methods do
    def score
      extending(ScoreScope).fetch_score
    end

    def favorites
      order("total" => :desc).score
    end

    def victims
      order("diff" => :desc, "win" => :desc, "lose" => :asc).score
    end

    def tormentors
      order("diff" => :asc, "lose" => :desc, "win" => :asc).score
    end
  end

  module ScoreScope
    COLUMNS = %w[win lose draw total diff]

    def fetch_score
      group_values.any? ? grouped_score : simple_score
    end

    private

    def grouped_score
      @klass.with_connection do |conn|
        conn.select_all(select_score, "#{self.class.name}#grouped_scores", async: @async).then do |rows|
          rows.map do |row|
            score = Score.new(**row.extract!(*COLUMNS))
            { row => score }
          end
        end
      end
    end

    def simple_score
      @klass.with_connection do |conn|
        conn.select_one(select_score, "#{self.class.name}#simple_score", async: @async)
          .then { |row| Score.new(**row.extract!(*COLUMNS)) }
      end
    end

    def select_score
      select(
        win.as("win"),
        lose.as("lose"),
        draw.as("draw"),
        diff.as("diff"),
        total.as("total"),
        *group_values
      )
    end

    def win
      ArelHelpers.count_if(arel_column("battle.winner_side").eq(arel_column("home_challenger.side")))
    end

    def lose
      ArelHelpers.count_if(arel_column("battle.winner_side").eq(arel_column("away_challenger.side")))
    end

    def draw
      ArelHelpers.count_if(arel_column("battle.winner_side").eq(nil))
    end

    def total
      Arel::Nodes::Count.new([ 1 ])
    end

    def diff
      Arel::Nodes::Subtraction.new(win, lose)
    end
  end
end
