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

    # TODO: determine when to use DST offset and when to use GMT offset
    offset = Forecast.format_offset(timezone.dst_offset)

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
  def self.format_offset(offset_int)
    num = offset_int.to_s
    if num[0] == '-'
      sign = '-'
      num = num[1..-1]
    else
      sign = '+'
    end
    num = num.length == 1 ? '0'+num : num
    sign + num + ":00"
  end

  # PSEUDOCODE
  # def distinct_clothing
  #   for each weather object in @forecast
  #     weather.get_appropriate_clothing
  #   superset = first weather object clothing
  #   for weather objects second..end
  #     for clothing in weather
  #       if clothing in superset
  #         delete clothing
  #       end
  #     end
  #     superset += remaining clothes
  #   end
  # end

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


  # def sunny?
  #   @weather_id == 800
  # end

  # def rainy?
  #   @weather_id >= 200 && @weather_id < 600
  # end

  # def condition
  #   if rainy?
  #     @condition_id = 400
  #   elsif sunny?
  #     @condition_id = 800
  #   else
  #     @condition_id = @weather_id
  #   end
  # end




  # def get_weather
  #   if by_geocode?
  #     Current.geocode(lat, long, OPEN_WEATHER_OPTIONS)
  #   elsif by_city?
  #     Current.city(city_country, OPEN_WEATHER_OPTIONS)
  #   end
  # end

  # def temperature
  #   @weather['main']['temp'].to_i
  # end


    # def get_clothing(temperature)
    #   body_parts = Wearable.get_body_parts

    #   clothes = body_parts.reduce({}) do |a, e|
    #     appropriate_clothes = Wearable.get_appropriate_clothing(e, { gender: "M" }, temperature)
    #     a[e] = appropriate_clothes unless appropriate_clothes.empty?
    #     a
    #   end
    # end

    # def forecast_unit(i)
    #   body_parts = Wearable.get_body_parts
    #   temperature = forecast['list'][i]['main']['temp']
    #   {
    #     time: DateTime.strptime(forecast['list'][i]['dt'].to_s, '%s'),
    #     temperature: temperature,
    #     weather_id: forecast['list'][i]['weather'][0]['id'],
    #     clothes: get_clothing(temperature).values.map { |e| e[0] }
    #   }
    # end
