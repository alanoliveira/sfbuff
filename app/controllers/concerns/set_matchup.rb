module SetMatchup
  extend ActiveSupport::Concern

  included do
    before_action :set_matchup
  end

  private

  def set_matchup
    @matchup = Matchup.new(matchup_parameters)
  end

  def matchup_parameters
    {}
  end
end
