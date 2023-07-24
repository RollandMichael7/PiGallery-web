Google::Maps.configure do |config|
  config.authentication_mode = Google::Maps::Configuration::API_KEY
  config.api_key = ENV["PIGALLERY_GOOGLE_MAPS_KEY"]
end
