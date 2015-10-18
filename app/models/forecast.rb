require 'open_weather'
require 'geonames_api'
require_relative 'weather'

class Forecast

  OPEN_WEATHER_OPTIONS = { units: "metric", APPID: "66cd0a1a0f9e1272ae428b4f5a9a1e9c" }

  attr_reader :forecast, :lat, :lon, :city_country, :num_slices, :sunrise, :sunset, :place_name

  # initialize a forecast object with the desired number of weather time slices
  # must be between 0 and 40.  if 0, @forecast only contains the current weather.
  # otherwise it is followed by 1-40 future forecasts for every 3 hours
  def initialize(config, num_slices = 0)
    @lat = config[:lat]
    @lon = config[:lon]
    @city_country = config[:city_country]
    @num_slices = num_slices_init(num_slices)
    setup_forecast
  end


  def setup_forecast
    forecast = []
    
    # do two api calls, one for the current weather, one for weather forecast  
    if by_geocode?
      current_forecast = OpenWeather::Current.geocode(lat, lon, OPEN_WEATHER_OPTIONS)
      full_forecast = num_slices == 0 ? nil : OpenWeather::Forecast.geocode(lat, lon, OPEN_WEATHER_OPTIONS)
    elsif by_city?
      current_forecast = OpenWeather::Current.city(city_country, OPEN_WEATHER_OPTIONS)
      full_forecast = num_slices == 0 ? nil : OpenWeather::Forecast.city(city_country, OPEN_WEATHER_OPTIONS)
    end

    timezone = GeoNamesAPI::TimeZone.find(current_forecast["coord"]["lat"], current_forecast["coord"]["lon"])
    puts "DST: " + timezone.dst_offset.to_s
    puts "GMT: " + timezone.gmt_offset.to_s
    puts "RAW: " + timezone.raw_offset.to_s

    # TODO: determine when to use DST offset and when to use GMT offset
    offset = Forecast.format_offset(timezone.dst_offset)
    puts "OFFSET: " + offset

    # we only want num_slices of the full forecast
    desired_results = num_slices == 0 ? nil : full_forecast["list"][0..num_slices - 1]

    # we also set some variables related to the current location
    unless lat && lon
      @lat = current_forecast["coord"]["lat"]
      @lon = current_forecast["coord"]["lon"]
    end
    @sunrise = Time.at(current_forecast["sys"]["sunrise"]).localtime(offset)
    @sunset = Time.at(current_forecast["sys"]["sunset"]).localtime(offset)

    @place_name = current_forecast["name"]

    # add Weather objects to @forecast array
    forecast << Weather.new(current_forecast, offset, sunrise, sunset)
    
    if num_slices > 0
      desired_results.each do |weather_data|
        forecast << Weather.new(weather_data, offset, sunrise, sunset)
      end
    end

    @forecast = forecast



  end

  # function to convert the DST/GMT offset integer returned by geonames to the string format
  # used by ruby's Time
  # e.g. converting -12..14 to '-12:00'..'+14:00'
  # but friggin kathmandu uses 5.75 which needs to become +05:45
  def self.format_offset(offset)
    offset = offset.to_s

    # first determine the sign, - or +
    if offset[0] == '-'
      sign = '-'
      offset = offset[1..-1]
    else
      sign = '+'
    end

    # if split gives us a one element array
    offset = offset.split(".")

    # get the hour, prepending a '0' if necessary
    hour = offset[0].length == 1 ? '0'+offset[0] : offset[0]

    # get the minutes, convert from e.g. 75 to 45 if necessary...  (see kathmandu above)
    mins = offset.length == 1 ? '00' : (offset[1].to_i * 0.6).to_i.to_s

    sign + hour + ":" + mins
  end

  private

    def by_geocode?
      lat && lon
    end

    def by_city?
      !city_country.nil?
    end

    def num_slices_init(num_slices)
      if num_slices <= 0
        0
      elsif num_slices >= 40
        40
      else
        num_slices
      end
    end

end