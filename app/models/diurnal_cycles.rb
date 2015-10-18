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

  class << self

    def add_cycle(cycle)
      @@cycles << cycle
    end

    def initialize(config)
      @@city_country = config[:city_country]
      @@lat = config[:lat]
      @@long = config[:long]
      @@duration = config[:duration]
      @@forecast = _forecast
      set_current_weather
    end

    def set_current_weather
      current_weather = _currentcast

      time = DateTime.strptime(current_weather['dt'].to_s, '%s')
      @@today = time.strftime( "%A" )

      current_weather_config = {
        time: time,
        temperature: current_weather['main']['temp'].to_i,
        weather_id: current_weather['weather'][0]['id'].to_i,
      }
      @@unit = DiurnalCycles.new({day: current_weather_config[:time].strftime( "%A" )})
      @@unit.add_unit Weather.new(current_weather_config)
      puts determine_amount_day_remaining
      generate_cycles(0)
    end

    def determine_amount_day_remaining
      (0..7).to_a.map { |i| _forecast_unit(i)[:time].strftime( "%A" ) != @@today }
    end

    def set_forecast_weather

    end

    def generate_cycles(i)
      @@unit = DiurnalCycles.new({day: _forecast_unit(i)[:time].strftime( "%A" )})
      i = generate_one_cycle(i)
      add_cycle(@@unit)
      generate_cycles(i + 1) if (i + 1) < (@@duration - 1) * DAILY
    end

    def generate_one_cycle(i)
      @@unit.add_unit Weather.new(_forecast_unit(i))
      generate_one_cycle(i + 1) if _forecast_unit(i + 1)[:time].strftime( "%A" ) == @@today
      @@today = _forecast_unit(i + 1)[:time].strftime( "%A" )
      puts "#{i}, #{@@today}"
      i
    end

    def city_country
      @@city_country
    end

    def lat
      @@lat
    end

    def long
      @@long
    end

    def cycles
      @@cycles
    end

    private
      def _by_geocode?
        @@lat && @@long
      end

      def _by_city?
        !@@city_country.nil?
      end

      def _currentcast
        if _by_city?
          OpenWeather::Current.city(@@city_country, OPEN_WEATHER_OPTIONS)
        elsif _by_geocode?
          OpenWeather::Current.geocode(@@lat, @@long, OPEN_WEATHER_OPTIONS)
        end
      end

      def _forecast
        if _by_city?
          OpenWeather::Forecast.city(@@city_country, OPEN_WEATHER_OPTIONS)
        elsif _by_geocode?
          OpenWeather::Forecast.geocode(@@lat, @@long, OPEN_WEATHER_OPTIONS)
        end
      end

      def _forecast_unit(i)
        {
          time: DateTime.strptime(_forecast['list'][i]['dt'].to_s, '%s'),
          temperature: temperature = _forecast['list'][i]['main']['temp'],
          weather_id: _forecast['list'][i]['weather'][0]['id']
        }
      end
  end
end
