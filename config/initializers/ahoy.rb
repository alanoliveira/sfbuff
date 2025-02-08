class Ahoy::Store < Ahoy::DatabaseStore
end

Ahoy.exclude_method = ->(_controller, _request) { Rails.env.local? }

# set to true for JavaScript tracking
Ahoy.api = false

# set to true for geocoding (and add the geocoder gem to your Gemfile)
# we recommend configuring local geocoding as well
# see https://github.com/ankane/ahoy#geocoding
Ahoy.geocode = true
Ahoy.job_queue = :low_priority

Ahoy.cookies = :none
