class Weather

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

  attr_reader :time, :temperature, :condition_id, :clothing, :sunrise, :sunset

  def initialize(open_weather_hash, timezone_offset, sunrise, sunset)
    @sunrise = sunrise
    @sunset = sunset
    process(open_weather_hash, timezone_offset)
    @clothing = nil
  end

  def sunny?
    @condition_id == CLEAR_SKY && sunrise < time && time < sunset
  end

  def rainy?
    WET_CONDITIONS.include?(@condition_id)
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
    if THUNDERSTORM.include?(@condition_id)
      'thunderstorm'
    elsif DRIZZLE.include?(@condition_id)
      'drizzle'
    elsif RAIN.include?(@condition_id)
      'rain'
    elsif SNOW.include?(@condition_id)
      'snow'
    else
      'sunshine'
    end
  end

  private

  def process(open_weather_hash, timezone_offset)
    @time = Time.at(open_weather_hash["dt"]).localtime(timezone_offset)
    @temperature = open_weather_hash["main"]["temp"]
    @condition_id = open_weather_hash["weather"][0]["id"]
  end

end
