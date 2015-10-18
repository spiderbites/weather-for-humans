require 'open_weather'

class Weather

  OPEN_WEATHER_OPTIONS = { units: "metric", APPID: "66cd0a1a0f9e1272ae428b4f5a9a1e9c" }

  attr_reader :lat, :long, :city_country, :weather_id, :condition_id, :forecast

  def initialize(config)
    @lat = config[:lat]
    @long = config[:long]
    @city_country = config[:city_country]
    @weather = get_weather
    @weather_id = get_weather['weather'][0]['id'].to_i
  end

  def get_weather
    if by_geocode?
      OpenWeather::Current.geocode(lat, long, OPEN_WEATHER_OPTIONS)
    elsif by_city?
      OpenWeather::Current.city(city_country, OPEN_WEATHER_OPTIONS)
    end
  end

  def temperature
    @weather['main']['temp'].to_i
  end

  def sunny?
    @weather_id == 800
  end

  def rainy?
    @weather_id >= 200 && @weather_id < 600
  end

  def condition
    if rainy?
      @condition_id = 400
    elsif sunny?
      @condition_id = 800
    else
      @condition_id = @weather_id
    end
  end

  private
    def by_geocode?
      lat && long
    end

    def by_city?
      !city_country.nil?
    end

end
