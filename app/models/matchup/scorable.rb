module Matchup::Scorable
  extend ActiveSupport::Concern

  included do
    scope :score, -> { extending(ScoreScope).then { |it| it.select_values.any? ? it.grouped_score : it.simple_score } }
    scope :favorites, -> { order("total" => :desc).score }
    scope :victims, -> { order("diff" => :desc, "win" => :desc, "lose" => :asc).score }
    scope :tormentors, -> { order("diff" => :asc, "lose" => :desc, "win" => :asc).score }
  end

  module ScoreScope
    COLUMNS = %w[win lose draw total diff]

    def grouped_score
      connection.select_all(select_score, "#{self.class.name}#grouped_scores").map do |row|
        score = Score.new(**row.extract!(*COLUMNS))
        { row => score }
      end
    end

    def simple_score
      row = connection.select_one(select_score, "#{self.class.name}#simple_score")
      Score.new(**row)
    end

    def select_score
      select(
        win.as("win"),
        lose.as("lose"),
        draw.as("draw"),
        diff.as("diff"),
        total.as("total")
      )
    end

    def win
      ArelHelpers.count_if(home_challenger_result_attribute.eq(Challenger.results["win"]))
    end

    def lose
      ArelHelpers.count_if(home_challenger_result_attribute.eq(Challenger.results["lose"]))
    end

    def draw
      ArelHelpers.count_if(home_challenger_result_attribute.eq(Challenger.results["draw"]))
    end

    def total
      Arel::Nodes::Count.new([ 1 ])
    end

    def diff
      Arel::Nodes::Subtraction.new(win, lose)
    end

    private

    def home_challenger_result_attribute
      predicate_builder.resolve_arel_attribute("home_challenger", :result)
    end
  end
end
