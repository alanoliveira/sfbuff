module MatchupCreatorHelper
  def create_matchups(wins: 0, losses: 0, draws: 0, **attrs)
    creator = MatchupCreator.new(attrs)
    wins.times { creator.win }
    losses.times { creator.loss }
    draws.times { creator.draw }
  end

  def create_matchup(result = :draw, **attrs)
    MatchupCreatorHelper::MatchupCreator.new(attrs).send(result)
  end

  private

  class MatchupCreator
    def initialize(attrs)
      @home_attrs, @away_attrs = [ "home", "away" ].map do |kind|
        attrs.filter { |k, v| k["#{kind}_"] }.transform_keys { it[/#{kind}_(.*)/, 1] }
      end
      @battle_attr = attrs.reject { |k, v| k[/home|away/] }
    end

    def win() create_matchup(:win, :loss) end
    def loss() create_matchup(:loss, :win) end
    def draw() create_matchup(:draw, :draw) end

    private

    def create_matchup(home_result, away_result)
      home = build(:challenger, home_result, **@home_attrs)
      away = build(:challenger, away_result, **@away_attrs)
      matchups = create(:battle, **@battle_attr, p1: home, p2: away).matchups
      {
        "home" => matchups.find { it.home_fighter_id = home.fighter_id },
        "away" => matchups.find { it.home_fighter_id = away.fighter_id }
      }
    end
  end
end
