class HumanVerifications::ValidationsController < ApplicationController
  skip_human_verification

  def create
    head :ok
  end
end
