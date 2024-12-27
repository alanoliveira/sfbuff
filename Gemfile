source "https://rubygems.org"

ruby file: ".ruby-version"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.0"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.5"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use sqlite3 as the database for Solid stuffs
gem "sqlite3", "~> 2.2"

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false

  # Unit tests
  gem "rspec-rails", "~> 7.0"

  # rubocop rspec linter
  gem "rubocop-rspec_rails", "~> 2.30"

  # Factory
  gem "factory_bot_rails", "~> 6.4"

  # erb linter
  gem "erb_lint", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  gem "kamal", "~> 2.3", require: false

  gem "hotwire-spark", "~> 0.1.12"
end

gem "faraday", "~> 2.12"
gem "faraday-cookie_jar", "~> 0.0.7"
gem "faraday-follow_redirects", "~> 0.3.0"

gem "rails-i18n", "~> 8.0"

gem "sentry-rails", "~> 5.19"

gem "stackprof", "~> 0.2.26"

gem "ahoy_matey", "~> 5.2"
gem "geoip", "~> 1.6"
gem "geocoder", "~> 1.8"

gem "pagy", "~> 9.2"

gem "selenium-webdriver", "~> 4.24"

gem "local_time", "~> 3.0"

gem "useragent", "~> 0.16.11"
