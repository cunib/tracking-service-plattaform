require 'google_maps_service'

# Setup global parameters
GoogleMapsService.configure do |config|
  config.key = 'AIzaSyD1dJH2gqf2s6e7bY3L2i9qS-w34rTdsJY'
  config.retry_timeout = 20
  config.queries_per_second = 10
end
