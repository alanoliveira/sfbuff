module Pagyable
  extend ActiveSupport::Concern

  included do
    before_action { @pagy_locale = I18n.locale.to_s }
  end

  def pagy_get_count(collection, vars)
    cache([ collection.cache_key, "pagy-count" ]) { collection.count }
  end

  def pagy_get_page(vars, force_integer: true)
    force_integer ? [ super, 1 ].max : super
  end
end
