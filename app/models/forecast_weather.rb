class ForecastWeather < Weather

  def initialize(config)
    super(config)
  end

  def get_forecast
    OpenWeather::Forecast.city(city_country, OPEN_WEATHER_OPTIONS)
  end

  def get_three_day_forecast
    @forecast = get_forecast
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

  private
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
