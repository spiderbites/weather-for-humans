class Weather
  attr_accessor :temperature, :weather_id, :condition_id, :time, :utc, :sunrise, :sunset

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

  def initialize(config)
    @temperature = config[:temperature]
    @weather_id = config[:weather_id]
    @time = config[:time]
    @utc = config[:utc]
    @sunrise = config[:sunrise]
    @sunset = config[:sunset]
    @condition_id = condition
  end

  def sunny?
    @weather_id == CLEAR_SKY && sunrise < utc && utc < sunset
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

end