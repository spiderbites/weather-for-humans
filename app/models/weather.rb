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

def temp
      determine_lat_long # Needed to determine timezone.
    @utc = get_weather['dt']
    @converted_time = Time.convert_utc_by_lat_long(utc, lat, long)
    def determine_lat_long
      unless by_geocode?
        @lat = get_weather['coord']['lat']
        @long = get_weather['coord']['lon']
      end
    end
end

class Weather
  attr_accessor :temperature, :weather_id, :condition_id, :time

  def initialize(config)
    @temperature = config[:temperature]
    @weather_id = config[:weather_id]
    @condition_id = config[:condition_id]
    @time = config[:time]
  end

  def to_s
    "Temperature: #{temperature}\nWeather_id: #{weather_id}\nCondition_id: #{condition_id}\nTime: #{time}"
  end
end