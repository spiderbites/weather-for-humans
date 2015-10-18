require 'open_weather'

class DiurnalCycles
  OPEN_WEATHER_OPTIONS = { units: "metric", APPID: "66cd0a1a0f9e1272ae428b4f5a9a1e9c" }
  THREE_HOURLY = 3
  DAILY = 7

  attr_reader :day, :cycle

  @@duration
  @@forecast
  @@cycles = []

  def initialize(config)
    @day = config[:day]
    @cycle = []
  end

  def add_unit(unit)
    @cycle << unit
  end

  def self.create(config)
    @@cycles << DiurnalCycles.new(config)
  end

  def self.initialize(config)
    @@city_country = config[:city_country]
    @@lat = config[:lat]
    @@long = config[:long]
    @@duration = config[:duration]
    @@forecast = _forecast

    generate_cycles(0)
  end

  def self.generate_cycles(i)
    @@unit = DiurnalCycles.new({day: forecast_unit(i)[:time].strftime( "%A" )})
    generate_one_cycle(i, i)
    @@cycles << @@unit
    generate_cycles(i + DAILY) if i < (@@duration - 1) * DAILY
  end

  def self.generate_one_cycle(i, j)
    @@unit.add_unit Weather.new(forecast_unit(j))
    generate_one_cycle(i, j + 1) if j < i + DAILY
  end

  def self.city_country
    @@city_country
  end

  def self.lat
    @@lat
  end

  def self.long
    @@long
  end

  def self.cycles
    @@cycles
  end

  private
    def self.by_geocode?
      @@lat && @@long
    end

    def self.by_city?
      !@@city_country.nil?
    end

    def self._forecast
      if by_city?
        OpenWeather::Forecast.city(@@city_country, OPEN_WEATHER_OPTIONS)
      elsif by_geocode?
        OpenWeather::Forecast.geocode(@@lat, @@long, OPEN_WEATHER_OPTIONS)
      end
    end

    def self.forecast_unit(i)
      {
        time: DateTime.strptime(_forecast['list'][i]['dt'].to_s, '%s'),
        temperature: temperature = _forecast['list'][i]['main']['temp'],
        weather_id: _forecast['list'][i]['weather'][0]['id']
      }
    end
end
