class BucklerController < ApplicationController
  layout "with_header_footer"

  def player_search
    @term = params[:q]
  end
end
