require "pagy/countless"
require "pagy/extras/bootstrap"
require "pagy/extras/overflow"
require "pagy/extras/countless"
Pagy::I18n.load(*I18n.available_locales.map { { locale: _1.to_s } })
Pagy::DEFAULT[:overflow] = :empty_page
