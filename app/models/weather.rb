require 'open_weather'

class Weather
  include OpenWeather

  OPEN_WEATHER_OPTIONS = { units: "metric", APPID: "66cd0a1a0f9e1272ae428b4f5a9a1e9c" }

  attr_reader :lat, :long, :city_country

  def initialize(config)
    @lat = config[:lat]
    @long = config[:long]
    @city_country = config[:city_country]
  end

  def get_weather
    if by_geocode?
      Current.geocode(lat, long, OPEN_WEATHER_OPTIONS)
    elsif by_city?
      Current.city(city_country, OPEN_WEATHER_OPTIONS)
    end
  end

  def get_temperature
    get_weather['main']['temp']
  end

  private
    def by_geocode?
      lat && long
    end

    def by_city?
      !city_country.nil?
    end
end