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
      appropriate_extras = Wearable.need_extras(e, weather.condition)
      a[e] = appropriate_extras unless appropriate_extras.empty?
      a
    end
    all_items = clothes.merge(extras)
  end
end

get '/location/:city_country' do
  @forecast = Forecast.new(params, 1)
  
  @weather = @forecast.forecast[0] #Weather.new(params)
  @all_weather = @forecast.forecast

  @clothes = get_clothing(@weather)
  @all_clothes = Wearable.prune(@all_weather.map{ |weather| get_clothing(weather) })
  erb :location
end

# get '/location' do
#   @forecast = Forecast.new(params, 1) # only get current temp for now
#   @weather = @forecast.forecast[0] #Weather.new(params)
#   @future_weather = @forecast.forecast[1]
#   @clothes = get_clothing(@weather)
#   @future_clothes = get_clothing(@future_weather)
#   erb :location
# end

post '/location' do
  redirect "location/#{params[:city_country]}"
end