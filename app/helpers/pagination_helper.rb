module PaginationHelper
  include Pagy::Frontend

  def paginate(pagy)
    return unless pagy.pages > 1
    pagy_bootstrap_nav(@pagy).html_safe
  end
end
