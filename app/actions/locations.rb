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

  def get_weather
    if by_geocode?
      get_current_weather_geocode
    elsif by_city?
      get_current_weather_city_country
    end
  end

  private
    def by_geocode?
      lat && long
    end

    def by_city?
      !city_country.nil?
    end
end

require 'open_weather'

get '/location' do
  @weather = Weather.new(params)

  erb :location
end

post '/location' do
  @weather = Weather.new(params)

  erb :location
end

helpers do

end