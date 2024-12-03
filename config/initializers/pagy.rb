require "pagy/extras/overflow"
Pagy::I18n.load(*I18n.available_locales.map { { locale: _1.to_s } })
Pagy::DEFAULT[:overflow] = :last_page
