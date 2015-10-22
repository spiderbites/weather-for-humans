require 'json'

helpers do
  def get_clothing(weather)
    body_parts = Wearable.get_body_parts

    clothes = body_parts.reduce({}) do |a, e|
      appropriate_clothes = Wearable.get_appropriate_clothing(e, { gender: "M" }, weather)
      a[e] = appropriate_clothes unless appropriate_clothes.empty?
      a
    end
    extras = body_parts.reduce({}) do |a,e|
      appropriate_extras = Wearable.need_extras(e, weather)
      a[e] = appropriate_extras unless appropriate_extras.empty?
      a
    end
    all_items = clothes.merge!(extras)
  end

  def background
    @all_weather ? @all_weather[0].condition_category_name : 'sunshine'
  end

end

get '/location/:city_country' do
  begin
    @forecast = Forecast.new(params, 4) # grab four future forecasts
    @all_weather = @forecast.forecast
    @all_clothes = Wearable.prune(@all_weather.map{ |weather| get_clothing(weather) })
  rescue Forecast::NoWeatherError => e
    @error = e.message
  end
  erb :location
end

get '/location' do
  begin
    @forecast = Forecast.new(params, 4)
    @all_weather = @forecast.forecast
    @all_clothes = Wearable.prune(@all_weather.map{ |weather| get_clothing(weather) })
  rescue Forecast::NoWeatherError => e
    @error = e.message
  end
  erb :location
end

post '/location' do
  redirect "location/#{params[:city_country]}"
end