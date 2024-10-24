class Matchup < ApplicationRecord
  include Scorable

  belongs_to :battle
  belongs_to :home_challenger, class_name: "Challenger"
  belongs_to :away_challenger, class_name: "Challenger"

  scope :ordered, -> { order("battle.played_at") }
  scope :by_home_short_id, ->(short_id) { where(home_challenger: { short_id: }) if short_id }

  default_scope do
    joins(:battle, :home_challenger, :away_challenger).tap do |it|
      # This is a workaround to this issue
      # https://github.com/rails/rails/issues/53063
      # TODO: remove it when the fix is released
      it.references_values |= [
        Arel.sql("battle", retryable: true),
        Arel.sql("away_challenger", retryable: true),
        Arel.sql("home_challenger", retryable: true)
      ]
    end
  end

  def readonly?
    true
  end

  def result
    case battle.winner_side
    when home_challenger.side then "win"
    when away_challenger.side then "lose"
    else "draw"
    end
  end

  def home_challenger
    battle.challengers.find { |c| c.id == home_challenger_id }
  end

  def away_challenger
    battle.challengers.find { |c| c.id == away_challenger_id }
  end
end
