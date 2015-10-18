require 'open_weather'
require 'open-uri'

class Time
  require 'tzinfo'

  def self.convert_utc_by_lat_long(utc, lat, long)
    api = "http://api.geonames.org/timezoneJSON?lat=#{lat}&lng=#{long}&username=demo"
    timezone = JSON.parse(open(api).read)['timezoneId']

    time = DateTime.strptime(utc.to_s, '%s')
    t = Time.parse(time.to_s)
    t.in_time_zone timezone #converted_time 2015-10-18 00:00:00 -0400
                            #converted_time 10/17/2015 11:00 PM EDT
  end

  # tzstring e.g. 'America/Los_Angeles'
  def in_timezone tzstring
    tz = TZInfo::Timezone.get tzstring
    p = tz.period_for_utc self
    e = self + p.utc_offset
    "#{e.strftime("%m/%d/%Y %I:%M %p")} #{p.zone_identifier}"
  end
end

class Weather

  OPEN_WEATHER_OPTIONS = { units: "metric", APPID: "66cd0a1a0f9e1272ae428b4f5a9a1e9c" }

  attr_reader :lat, :long, :city_country, :weather_id, :condition_id

  attr_reader :utc, :converted_time

  attr_accessor :time, :clothes

  def initialize(config)
    @lat = config[:lat]
    @long = config[:long]
    @city_country = config[:city_country]
    @weather = get_weather
    @weather_id = get_weather['weather'][0]['id'].to_i

    determine_lat_long # Needed to determine timezone.
    @utc = get_weather['dt']
    @converted_time = Time.convert_utc_by_lat_long(utc, lat, long)

    puts '','','','', "converted_time #{converted_time}"
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

    def determine_lat_long
      unless by_geocode?
        @lat = get_weather['coord']['lat']
        @long = get_weather['coord']['lon']
      end
    end
end
