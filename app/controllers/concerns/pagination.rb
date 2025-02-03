module Pagination
  include Pagy::Backend

  def pagy_get_page(vars, force_integer: true)
    force_integer ? [ super, 1 ].max : super
  end
end
