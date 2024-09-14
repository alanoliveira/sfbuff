class Players::RankedsController < Players::BaseController
  def show
    @filter_form = Players::RankedFilterForm.new(player: @player)
    @filter_form.fill(params)
    @history = @filter_form.submit
  end
end
