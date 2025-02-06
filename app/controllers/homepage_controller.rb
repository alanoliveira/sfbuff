class HomepageController < ApplicationController
  skip_before_action :require_timezone

  def index
  end
end
