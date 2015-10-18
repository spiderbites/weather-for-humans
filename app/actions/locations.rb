require 'json'

get '/location/:city_country/data' do
  content_type :json

  @weather = ForecastWeather.new(params)
  forecast = @weather.get_three_day_forecast
  forecast.to_json
end

get '/location/:city_country' do
  @city_country = params[:city_country]
  erb :location
end

get '/location' do
  @weather = ForecastWeather.new(params)
  erb :location
end

post '/location' do
  redirect "location/#{params[:city_country]}"
end