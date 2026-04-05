class PagesController < ApplicationController
  skip_human_verification
  allow_indexing only: :index

  def index
  end

  def about
  end

  def fair_use_agreement
  end
end
