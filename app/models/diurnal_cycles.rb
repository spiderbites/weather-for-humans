require 'open_weather'

class DiurnalCycles
  OPEN_WEATHER_OPTIONS = { units: "metric", APPID: "66cd0a1a0f9e1272ae428b4f5a9a1e9c" }

  attr_reader :day, :cycle

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
      @@forecast = _forecast
      _set_today_weather
      _set_forecast_weather
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

      def _current_weather_cast
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

        utc = @@forecast['list'][i]['dt']
        {
          time: DateTime.strptime(utc.to_s, '%s'),
          utc: utc,
          sunrise: @@current_weather['sys']['sunrise'], # assuming that no drastic change occurs in three days time.
          sunset: @@current_weather['sys']['sunset'],
          temperature: temperature = @@forecast['list'][i]['main']['temp'],
          weather_id: @@forecast['list'][i]['weather'][0]['id']
        }
      end

      def _set_today_weather
        @@current_weather = _current_weather_cast

        utc = @@current_weather['dt']
        time = DateTime.strptime(utc.to_s, '%s')
        @@today = time.strftime( "%A" )

        current_weather_config = {
          time: time,
          utc: utc,
          sunrise: @@current_weather['sys']['sunrise'],
          sunset: @@current_weather['sys']['sunset'],
          temperature: @@current_weather['main']['temp'].to_i,
          weather_id: @@current_weather['weather'][0]['id'].to_i,
        }

        @@diurnal_cycle = DiurnalCycles.new({day: current_weather_config[:time].strftime( "%A" )})
        @@diurnal_cycle.add_unit Weather.new(current_weather_config)

        i = _determine_amount_day_remaining

        _generate_cycles((0..i-1).to_a)
      end

      def _set_forecast_weather
        i = _determine_amount_day_remaining

        @@diurnal_cycle = DiurnalCycles.new({day: _forecast_unit(i)[:time].strftime( "%A" )})
        _generate_cycles((i..i+7).to_a)

        @@diurnal_cycle = DiurnalCycles.new({day: _forecast_unit(i+8)[:time].strftime( "%A" )})
        _generate_cycles((i+8..i+15).to_a)
      end

      def _generate_cycles(day)
        day.each do |i|
          @@diurnal_cycle.add_unit Weather.new(_forecast_unit(i))
        end
        add_cycle(@@diurnal_cycle)
      end

      def _determine_amount_day_remaining
        (0..7).to_a.select { |i| _forecast_unit(i)[:time].strftime( "%A" ) == @@today }.length
      end
  end
end
