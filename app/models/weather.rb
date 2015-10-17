require 'open_weather'

class Weather
  include OpenWeather

  OPEN_WEATHER_OPTIONS = { units: "metric", APPID: "66cd0a1a0f9e1272ae428b4f5a9a1e9c" }

  # open weather map condition codes
  #   http://openweathermap.org/weather-conditions
  THUNDERSTORM = (200..232)
  DRIZZLE = (300..321)
  RAIN = (500..531)
  WET_CONDITIONS = (200..531)
  SNOW = (600..622)
  CLEAR_SKY = 800


  # our magic number for rain in the strange zone uninhabited by open weather map
  HUMANS_RAIN = 400
  UNTRACKED_CONDITION = 0

  attr_reader :lat, :long, :city_country, :weather_id, :condition_id

  def initialize(config)
    @lat = config[:lat]
    @long = config[:long]
    @city_country = config[:city_country]
    @weather = get_weather
    @weather_id = get_weather['weather'][0]['id'].to_i
  end

  def get_weather
    if by_geocode?
      Current.geocode(lat, long, OPEN_WEATHER_OPTIONS)
    elsif by_city?
      Current.city(city_country, OPEN_WEATHER_OPTIONS)
    end
  end

  def temperature
    @weather['main']['temp'].to_i
  end

  def sunny?
    current_time = @weather['dt']
    sunrise = @weather['sys']['sunrise']
    sunset = @weather['sys']['sunset']
    @weather_id == CLEAR_SKY && sunrise < current_time && current_time < sunset
  end

  def rainy?
    WET_CONDITIONS.include?(@weather_id)
  end

  def condition
    if rainy?
      @condition_id = HUMANS_RAIN
    elsif sunny?
      @condition_id = CLEAR_SKY
    else
      @condition_id = UNTRACKED_CONDITION
    end
  end

  # this rather pedantic method is used in determining the background image to load
  def condition_category_name
    if THUNDERSTORM.include?(@weather_id)
      'thunderstorm'
    elsif DRIZZLE.include?(@weather_id)
      'drizzle'
    elsif RAIN.include?(@weather_id)
      'rain'
    elsif SNOW.include?(@weather_id)
      'snow'
    else
      'sunshine'
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