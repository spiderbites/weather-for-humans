
require 'open_weather'
require 'geonames_api'
require 'net/http'
require 'json'
require_relative 'weather'

class Forecast

  OPEN_WEATHER_OPTIONS = { units: "metric", APPID: "66cd0a1a0f9e1272ae428b4f5a9a1e9c" }
  GeoNamesAPI.username = "joshzucker"
  GEONAMES_API_USER = "joshzucker"
  
  CITY_NOT_FOUND = "404"

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

    current_forecast = get_weather

    if current_forecast.nil?
      raise NoWeatherError.new(city_country, lat, lon)
    end
    
    full_forecast = get_weather(current=false)
    
    # set lat, lon, city_country vars where we lack that info
    set_place_vars(current_forecast)

    timezone = GeoNamesAPI::TimeZone.find(lat, lon)

    # TODO: determine when to use DST offset and when to use GMT offset
    offset = Forecast.format_offset(timezone.dst_offset)

    # we only want num_slices of the full forecast
    desired_results = num_slices == 0 ? nil : full_forecast["list"][0..num_slices - 1]

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
    hour = offset[0].length == 1 ? '0' + offset[0] : offset[0]

    # get the minutes, convert from e.g. 75 to 45 if necessary...  (see kathmandu above)
    if offset.length == 1
      mins = '00'
    else
      mins = (offset[1].to_i * 0.6).to_i.to_s
      mins = mins.length == 1 ? '0' + mins : mins
    end

    sign + hour + ":" + mins
  end

  class NoWeatherError < StandardError
    def initialize(city_country, lat, lon)
      message = "Hmmm, we couldn't find weather for:"
      message += " City: #{city_country}" if city_country
      message += " Latitude: #{lat}" if lat
      message += " Longitude: #{lon}" if lon
      super(message)
    end
  end

  private

    def get_weather(current=true)
      open_weather = current ? OpenWeather::Current : OpenWeather::Forecast
      if by_geocode?
        response = open_weather.geocode(lat, lon, OPEN_WEATHER_OPTIONS)  
      elsif by_city?
        response = open_weather.city(city_country, OPEN_WEATHER_OPTIONS)
      end
      response['cod'] == CITY_NOT_FOUND ? nil : response
    end

    def geonames_nearby_place(lat,lon)
      URI("http://api.geonames.org/findNearbyPlaceNameJSON?lat=#{lat}&lng=#{lon}&username=#{GEONAMES_API_USER}")
    end

    def set_place_vars(current_forecast)
      if by_geocode? # then we need the city/country
        res = JSON.parse(Net::HTTP.get(geonames_nearby_place(lat, lon)))
        puts "CITY COUNTRY... " + res.inspect
        city = res["geonames"].empty? ? "Unknown" : res["geonames"][0]["name"]
        country = res["geonames"].empty? ? "Unknown" : res["geonames"][0]["countryName"]
        @city_country = city + ", " + country
      elsif by_city? # set the lat/lon vars
        @lat = current_forecast["coord"]["lat"]
        @lon = current_forecast["coord"]["lon"]
      end
    end

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