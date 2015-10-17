require 'open_weather'

class Weather
  include OpenWeather

  OPEN_WEATHER_OPTIONS = { units: "metric", APPID: "66cd0a1a0f9e1272ae428b4f5a9a1e9c" }

  attr_reader :lat, :long, :city_country, :weather_id, :condition_id, :forecast

  def initialize(config)
    @lat = config[:lat]
    @long = config[:long]
    @city_country = config[:city_country]
    @weather = get_weather
    @weather_id = get_weather['weather'][0]['id'].to_i
    @forecast = get_forecast
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


  def get_forecast
    Forecast.city(city_country, OPEN_WEATHER_OPTIONS)
  end

  def get_three_day_forecast
    day1 = (0..6).to_a
    day2 = (7..14).to_a
    day3 = (15..22).to_a
    [
      {
        day: forecast_unit(0)[:time].strftime( "%A" ),
        cycle: day1.map { |d| forecast_unit(d) }
        },
      {
        day: forecast_unit(8)[:time].strftime( "%A" ),
        cycle: day2.map { |d| forecast_unit(d) }
        },
      {
        day: forecast_unit(16)[:time].strftime( "%A" ),
        cycle: day3.map { |d| forecast_unit(d) }
      }
    ]
  end

  def test_time_zone
    # puts in_timezone 'CA', 'Toronto'
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

    def get_clothing(temperature)
      body_parts = Wearable.get_body_parts

      clothes = body_parts.reduce({}) do |a, e|
        appropriate_clothes = Wearable.get_appropriate_clothing(e, { gender: "M" }, temperature)
        a[e] = appropriate_clothes unless appropriate_clothes.empty?
        a
      end
    end

    def forecast_unit(i)
      body_parts = Wearable.get_body_parts
      temperature = forecast['list'][i]['main']['temp']
      {
        time: DateTime.strptime(forecast['list'][i]['dt'].to_s, '%s'),
        temperature: temperature,
        weather_id: forecast['list'][i]['weather'][0]['id'],
        clothes: get_clothing(temperature).values.map { |e| e[0] }
      }
    end
end