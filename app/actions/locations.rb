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
end

get '/location/:city_country' do
  @forecast = Forecast.new(params, 4)
  
  @weather = @forecast.forecast[0]
  @all_weather = @forecast.forecast

  @clothes = get_clothing(@weather) 
  
  clothes_list = @all_weather.map{ |weather| get_clothing(weather) }
  @all_clothes = Wearable.prune(@all_weather.map{ |weather| get_clothing(weather) })

  puts "ALL WEATHER " + @all_weather.inspect
  puts "ALL CLOTHES " + @all_clothes.inspect

  erb :"location.forecast_model"
end

get '/location' do
  erb :location
end

post '/location' do
  redirect "location/#{params[:city_country]}"
end