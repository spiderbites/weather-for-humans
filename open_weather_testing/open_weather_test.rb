require 'open_weather'
require 'pry'

options = { units: "metric", APPID: "66cd0a1a0f9e1272ae428b4f5a9a1e9c" }

binding.pry
# get current weather by city name
current = OpenWeather::Current.city("Toronto, CA", options)
puts current

# get weather forecast by city name
forecast = OpenWeather::Forecast.city("Toronto, CA", options)
puts forecast

# get daily weather forecast by city name
daily_forecast = OpenWeather::ForecastDaily.city("Toronto, CA", options)
puts daily_forecast