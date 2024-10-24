module Pagyable
  extend ActiveSupport::Concern

  included do
    before_action { @pagy_locale = I18n.locale.to_s }
  end

  def pagy_get_count(collection, vars)
    cache([ collection.cache_key, "pagy-count" ]) { collection.count }
  end
end
