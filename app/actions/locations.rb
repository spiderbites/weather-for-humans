require 'json'

helpers do
  def get_clothing(weather)
    Wearable.get_appropriate_clothing({}, weather)
  end
end

get '/location/:city_country' do
  @forecast = Forecast.new(params) # default is current weather + four future time slices
  @all_weather = @forecast.forecast
  @all_clothes = Wearable.prune(@all_weather.map{ |weather| get_clothing(weather) })
  erb :"location"
end

get '/location' do
  @forecast = Forecast.new(params)
  @all_weather = @forecast.forecast
  @all_clothes = Wearable.prune(@all_weather.map{ |weather| get_clothing(weather) })
  erb :location
end

post '/location' do
  redirect "location/#{params[:city_country]}"
end