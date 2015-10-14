require 'open_weather'

get '/location' do
  if params[:lat] && params[:long]
    @current_weather = get_current_weather_geocode(params[:lat], params[:long])
  end

  erb :location
end 

post '/location' do
  if params[:city_country]
    @current_weather = get_current_weather_city_country(params[:city_country])
  end

  erb :location
end

helpers do

  def open_weather_options
    { units: "metric", APPID: "66cd0a1a0f9e1272ae428b4f5a9a1e9c" }
  end

  def get_current_weather_geocode(lat, long)
    OpenWeather::Current.geocode(lat, long, open_weather_options)
  end

  def get_current_weather_city_country(city_country)
    # for now assuming user input is valid, should error check, or better yet error check on front page
    OpenWeather::Current.city(city_country, open_weather_options)
  end

end