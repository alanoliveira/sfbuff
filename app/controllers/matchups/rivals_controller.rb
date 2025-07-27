class Matchups::RivalsController < ApplicationController
  include SetMatchups

  def show
    @rivals = @matchups.limit(8).rivals
  end
end
