class Weather
  OPEN_WEATHER_OPTIONS = { units: "metric", APPID: "66cd0a1a0f9e1272ae428b4f5a9a1e9c" }

  attr_reader :lat, :long, :city_country

  def initialize(config)
    @lat = config[:lat]
    @long = config[:long]
    @city_country = config[:city_country]
  end

  def get_current_weather_geocode
    OpenWeather::Current.geocode(lat, long, OPEN_WEATHER_OPTIONS)
  end

  def get_current_weather_city_country
    # for now assuming user input is valid, should error check, or better yet error check on front page
    OpenWeather::Current.city(city_country, OPEN_WEATHER_OPTIONS)
  end

end

require 'open_weather'

get '/location' do
  if params[:lat] && params[:long]
    @weather = Weather.new(params)
    @current_weather = @weather.get_current_weather_geocode
  end

  erb :location
end

post '/location' do
  if params[:city_country]
    @weather = Weather.new(params)
    @current_weather = @weather.get_current_weather_city_country
  end

  erb :location
end

helpers do

end